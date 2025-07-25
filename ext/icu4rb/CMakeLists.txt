cmake_minimum_required(VERSION 3.15)
project(icu4rb)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find ICU with Homebrew path for macOS
find_path(ICU_INCLUDE_DIR unicode/unistr.h
    PATHS /opt/homebrew/opt/icu4c@77/include
    REQUIRED
)

find_library(ICU_I18N_LIBRARY icui18n
    PATHS /opt/homebrew/opt/icu4c@77/lib
    REQUIRED
)

find_library(ICU_UC_LIBRARY icuuc
    PATHS /opt/homebrew/opt/icu4c@77/lib
    REQUIRED
)

set(ICU_LIBRARIES ${ICU_I18N_LIBRARY} ${ICU_UC_LIBRARY})
set(ICU_INCLUDE_DIRS ${ICU_INCLUDE_DIR})

# Find Ruby
set(Ruby_ROOT_DIR /Users/pigoz/.rbenv/versions/3.4.4)
find_package(Ruby REQUIRED)

# Create the shared library
add_library(icu4rb MODULE icu4rb.cpp)

# Include directories
target_include_directories(icu4rb PRIVATE 
    ${ICU_INCLUDE_DIRS}
    ${Ruby_INCLUDE_DIRS}
)

# Link libraries
target_link_libraries(icu4rb PRIVATE 
    ${ICU_LIBRARIES}
    ${Ruby_LIBRARIES}
)

# Set properties for Ruby extension
set_target_properties(icu4rb PROPERTIES
    PREFIX ""
    SUFFIX ".${Ruby_SOEXT}"
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
)

# Set compiler flags
target_compile_options(icu4rb PRIVATE 
    -fPIC
    -Wno-reserved-user-defined-literal
    -Wno-register
    -Wno-deprecated-declarations
    -Wno-typedef-redefinition
)

# Install to the lib directory
install(TARGETS icu4rb DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/../../lib/icu4rb)