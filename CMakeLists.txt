cmake_minimum_required(VERSION 3.20)
project(ccl LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(BISON 3.0 REQUIRED)
find_package(FLEX  2.6 REQUIRED)

# macOS landmine: Apple ships GNU M4 1.4.6 (from 2007) at /usr/bin/m4.
# Flex 2.6.4 needs a newer m4 and fails *silently* with the old one
# (exit 1, zero output, empty stderr). If we can find Homebrew's m4,
# point flex at it via the M4 environment variable.
set(FLEX_M4_WRAPPER)
if(APPLE)
    find_program(HOMEBREW_M4 m4
        PATHS /opt/homebrew/opt/m4/bin /usr/local/opt/m4/bin
        NO_DEFAULT_PATH)
    if(HOMEBREW_M4)
        set(FLEX_M4_WRAPPER ${CMAKE_COMMAND} -E env "M4=${HOMEBREW_M4}")
    else()
        message(WARNING
            "Homebrew m4 not found. Apple's /usr/bin/m4 is too old "
            "for flex 2.6.4 and flex will fail silently. "
            "Install with: brew install m4")
    endif()
endif()

set(PARSER_CPP ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
set(PARSER_HPP ${CMAKE_CURRENT_BINARY_DIR}/parser.hpp)
set(LEXER_CPP  ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

add_custom_command(
    OUTPUT  ${PARSER_CPP} ${PARSER_HPP}
    COMMAND ${BISON_EXECUTABLE} -d -o ${PARSER_CPP}
            ${CMAKE_CURRENT_SOURCE_DIR}/parser.y
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/parser.y
    COMMENT "Bison: parser.y"
    VERBATIM)

add_custom_command(
    OUTPUT  ${LEXER_CPP}
    COMMAND ${FLEX_M4_WRAPPER} ${FLEX_EXECUTABLE} -o ${LEXER_CPP}
            ${CMAKE_CURRENT_SOURCE_DIR}/lexer.l
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/lexer.l ${PARSER_HPP}
    COMMENT "Flex: lexer.l"
    VERBATIM)

add_library(ccl STATIC
    App.cpp
    Clause.cpp
    Debug.cpp
    Eval.cpp
    Expr.cpp
    Internals.cpp
    List.cpp
    Program.cpp
    Scope.cpp
    Schedulers.cpp
    Symbol.cpp
    SymbolTable.cpp
    Type.cpp
    TypeCheck.cpp
    ${PARSER_CPP}
    ${LEXER_CPP})

target_include_directories(ccl
    PUBLIC  ${CMAKE_CURRENT_SOURCE_DIR}
    PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

# Match ccl.pro: this old code emits many warnings that aren't actionable.
target_compile_options(ccl PRIVATE -w)
