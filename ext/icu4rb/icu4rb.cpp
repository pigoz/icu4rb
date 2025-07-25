#include <ruby.h>
#include <ruby/encoding.h>

// Handle UChar conflict with Ruby's OnigUChar
#ifdef UChar
#undef UChar
#endif

#include <unicode/msgfmt.h>
#include <unicode/unistr.h>
#include <unicode/ustring.h>
#include <unicode/locid.h>
#include <unicode/uclean.h>
#include <unicode/parsepos.h>
#include <string>
#include <vector>

// Structure to hold the MessageFormatter instance
typedef struct {
    icu::MessageFormat* formatter;
    char* locale;
} rb_icu_message_formatter;

// Function to check ICU error codes
static UErrorCode check_icu_error(UErrorCode status) {
    if (U_FAILURE(status)) {
        rb_raise(rb_eRuntimeError, "ICU Error: %s", u_errorName(status));
    }
    return status;
}

// Allocation function for MessageFormatter
static VALUE rb_icu_message_formatter_alloc(VALUE klass) {
    rb_icu_message_formatter* mf;
    VALUE obj = Data_Make_Struct(klass, rb_icu_message_formatter, NULL, -1, mf);
    mf->formatter = NULL;
    mf->locale = NULL;
    return obj;
}

// Initialization function for MessageFormatter
static VALUE rb_icu_message_formatter_initialize(int argc, VALUE* argv, VALUE self) {
    VALUE pattern, locale_str;
    rb_scan_args(argc, argv, "11", &pattern, &locale_str);
    
    if (NIL_P(locale_str)) {
        locale_str = rb_str_new2("en_US");
    }
    
    rb_icu_message_formatter* mf;
    Data_Get_Struct(self, rb_icu_message_formatter, mf);
    
    // Convert Ruby strings to C strings
    char* c_pattern = StringValueCStr(pattern);
    char* c_locale = StringValueCStr(locale_str);
    
    // Create ICU objects
    UErrorCode status = U_ZERO_ERROR;
    icu::Locale locale = icu::Locale::createFromName(c_locale);
    
    icu::UnicodeString u_pattern(c_pattern, strlen(c_pattern));
    mf->formatter = new icu::MessageFormat(u_pattern, locale, status);
    check_icu_error(status);
    
    // Store locale
    mf->locale = strdup(c_locale);
    
    return self;
}

// Format method
static VALUE rb_icu_message_formatter_format(VALUE self, VALUE args_hash) {
    rb_icu_message_formatter* mf;
    Data_Get_Struct(self, rb_icu_message_formatter, mf);
    
    if (!mf->formatter) {
        rb_raise(rb_eRuntimeError, "Formatter not initialized");
    }
    
    // Build argument map from Ruby hash
    std::vector<icu::Formattable> arguments;
    std::vector<icu::UnicodeString> argument_names;
    
    // Get all key-value pairs from Ruby hash
    VALUE keys = rb_funcall(args_hash, rb_intern("keys"), 0);
    int key_count = RARRAY_LENINT(keys);
    
    for (int i = 0; i < key_count; ++i) {
        VALUE key = rb_ary_entry(keys, i);
        VALUE value = rb_hash_aref(args_hash, key);
        
        char* key_str = StringValueCStr(key);
        argument_names.emplace_back(key_str, strlen(key_str));
        
        if (NIL_P(value)) {
            arguments.emplace_back("");
        } else if (TYPE(value) == T_FIXNUM || TYPE(value) == T_BIGNUM) {
            int64_t int_value = NUM2LL(value);
            // Handle large integers (likely timestamps) as Date objects
            if (int_value > 1000000000000LL) {  // Likely milliseconds since epoch
                // Convert milliseconds to seconds for ICU
                double seconds = (double)int_value / 1000.0;
                arguments.emplace_back(seconds);
            } else {
                arguments.emplace_back((int32_t)int_value);
            }
        } else if (TYPE(value) == T_FLOAT) {
            arguments.emplace_back(NUM2DBL(value));
        } else {
            char* value_str = StringValueCStr(value);
            arguments.emplace_back(icu::UnicodeString(value_str, strlen(value_str)));
        }
    }
    
    // Format the message
    icu::UnicodeString result;
    UErrorCode status = U_ZERO_ERROR;
    
    if (arguments.empty()) {
        // No arguments, just return pattern
        mf->formatter->toPattern(result);
    } else {
        // Format with arguments - use correct ICU MessageFormat API
        // For MessageFormat, we need to use the format method that takes Formattable*
        
        // Create arrays for arguments
        icu::Formattable* formattableArgs = new icu::Formattable[arguments.size()];
        icu::UnicodeString* argumentNames = new icu::UnicodeString[argument_names.size()];
        
        for (size_t i = 0; i < arguments.size(); ++i) {
            formattableArgs[i] = arguments[i];
            argumentNames[i] = argument_names[i];
        }
        
        // Use the correct ICU MessageFormat API
        mf->formatter->format(argumentNames, formattableArgs, arguments.size(), result, status);
        
        delete[] formattableArgs;
        delete[] argumentNames;
    }
    check_icu_error(status);
    
    // Convert result to UTF-8
    int32_t buffer_size = result.length() * 4 + 1;
    char* buffer = (char*)malloc(buffer_size);
    int32_t length = result.extract(0, result.length(), buffer, buffer_size, nullptr);
    
    VALUE ruby_result = rb_str_new(buffer, length);
    rb_enc_associate(ruby_result, rb_utf8_encoding());
    free(buffer);
    
    return ruby_result;
}

// Getter for locale
static VALUE rb_icu_message_formatter_get_locale(VALUE self) {
    rb_icu_message_formatter* mf;
    Data_Get_Struct(self, rb_icu_message_formatter, mf);
    
    return rb_str_new2(mf->locale ? mf->locale : "");
}

// Getter for pattern
static VALUE rb_icu_message_formatter_get_pattern(VALUE self) {
    rb_icu_message_formatter* mf;
    Data_Get_Struct(self, rb_icu_message_formatter, mf);
    
    if (!mf->formatter) {
        return rb_str_new2("");
    }
    
    icu::UnicodeString pattern;
    mf->formatter->toPattern(pattern);
    
    int32_t buffer_size = pattern.length() * 4 + 1;
    char* buffer = (char*)malloc(buffer_size);
    int32_t length = pattern.extract(0, pattern.length(), buffer, buffer_size, nullptr);
    
    VALUE ruby_result = rb_str_new(buffer, length);
    rb_enc_associate(ruby_result, rb_utf8_encoding());
    free(buffer);
    
    return ruby_result;
}

// GC mark function
static void rb_icu_message_formatter_mark(void* ptr) {
    // Nothing to mark
}

// GC free function
static void rb_icu_message_formatter_free(void* ptr) {
    rb_icu_message_formatter* mf = (rb_icu_message_formatter*)ptr;
    if (mf->formatter) {
        delete mf->formatter;
    }
    if (mf->locale) {
        free(mf->locale);
    }
    free(mf);
}

// Initialize the extension
extern "C" void Init_icu4rb(void) {
    // Initialize ICU
    UErrorCode status = U_ZERO_ERROR;
    u_init(&status);
    if (U_FAILURE(status)) {
        rb_raise(rb_eRuntimeError, "Failed to initialize ICU: %s", u_errorName(status));
    }
    
    // Define the ICU module
    VALUE rb_mICU = rb_define_module("ICU");
    
    // Define the MessageFormatter class
    VALUE rb_cMessageFormatter = rb_define_class_under(rb_mICU, "MessageFormatter", rb_cObject);
    
    // Set up the allocator and destructor
    rb_define_alloc_func(rb_cMessageFormatter, rb_icu_message_formatter_alloc);
    
    // Define methods
    rb_define_method(rb_cMessageFormatter, "initialize", RUBY_METHOD_FUNC(rb_icu_message_formatter_initialize), -1);
    rb_define_method(rb_cMessageFormatter, "format", RUBY_METHOD_FUNC(rb_icu_message_formatter_format), 1);
    rb_define_method(rb_cMessageFormatter, "locale", RUBY_METHOD_FUNC(rb_icu_message_formatter_get_locale), 0);
    rb_define_method(rb_cMessageFormatter, "pattern", RUBY_METHOD_FUNC(rb_icu_message_formatter_get_pattern), 0);
}