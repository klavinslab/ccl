#-------------------------------------------------
#
# Project created by QtCreator 2012-05-26T17:40:42
# And then edited some by Eric Klavins.
#-------------------------------------------------

win32 {
  QMAKE_CXXFLAGS += -O3 -DWIN -w
}

macx {
  QMAKE_CXXFLAGS += -w
}

linux-g++* {
  QMAKE_CXXFLAGS += -Ofast -DLINUX -w
}

QT       -= core gui

TARGET = ccl
TEMPLATE = lib
CONFIG += staticlib

SOURCES += TypeCheck.cpp \
    Type.cpp \
    SymbolTable.cpp \
    Symbol.cpp \
    Scope.cpp \
    Schedulers.cpp \
    Program.cpp \
    List.cpp \
    Internals.cpp \
    Expr.cpp \
    Eval.cpp \
    Debug.cpp \
    Clause.cpp \
    App.cpp

HEADERS += Expr.h \
    SymbolTable.h \
    Program.h \
    parser.h \
    Schedulers.h \
    Type.h \
    ccl.h

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/lib
    } else {
        target.path = /usr/lib
    }
    INSTALLS += target
}

OTHER_FILES += \
    parser.y \
    lexer.l \
    LICENSE \
    .gitignore


include(flex.pri)
include(bison.pri)
FLEXSOURCES = lexer.l
BISONSOURCES = parser.y

QMAKE_CLEAN += Makefile libccl.a
