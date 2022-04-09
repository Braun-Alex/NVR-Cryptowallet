cmake_minimum_required(VERSION 3.14)
include(FetchContent)
FetchContent_Declare(
  Qaterial
  GIT_REPOSITORY https://github.com/OlivierLDff/Qaterial.git
  GIT_TAG        master
  GIT_SHALLOW    1
)
FetchContent_MakeAvailable(Qaterial)
project(Cryptowallet VERSION 0.1 LANGUAGES CXX)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(OPENSSL_USE_STATIC_LIBS ON)
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick Sql Network REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick Sql Network REQUIRED)
set(PROJECT_SOURCES
    main.cpp
    resources.h
    smtp/emailaddress.h
    smtp/mimeattachment.h
    smtp/mimefile.h
    smtp/mimehtml.h
    smtp/mimeinlinefile.h
    smtp/mimemessage.h
    smtp/mimepart.h
    smtp/mimetext.h
    smtp/smtpclient.h
    smtp/SmtpMime
    smtp/quotedprintable.h
    smtp/mimemultipart.h
    smtp/mimecontentformatter.h
    smtp/smtpexports.h
    smtp/emailaddress.cpp
    smtp/mimeattachment.cpp
    smtp/mimefile.cpp
    smtp/mimehtml.cpp
    smtp/mimeinlinefile.cpp
    smtp/mimemessage.cpp
    smtp/mimepart.cpp
    smtp/mimetext.cpp
    smtp/smtpclient.cpp
    smtp/quotedprintable.cpp
    smtp/mimemultipart.cpp
    smtp/mimecontentformatter.cpp
    orm/user.h
    orm/user.cpp
    orm/inactivated_user.h
    orm/inactivated_user.cpp
    orm/cryptowallet.h
    orm/cryptowallet.cpp
    account_handler.h
    account_handler.cpp
    cryptography/qaesencryption.h
    cryptography/qaesencryption.cpp
    nvr/utils.h
    nvr/utils.cpp
    rc/cryptowallet.rc
    qml.qrc)
set(QXORM_DIR "C:/Users/Lamaba/Desktop/Projects/QxOrm")
set(POSTGRESQL_DIR "C:/PostgreSQL/14")
set(QXORM_LIB "${QXORM_DIR}/lib/libQxOrm.dll.a")
set(POSTGRESQL_LIBS "${POSTGRESQL_DIR}/lib/")
set(QXORM_INCLUDE_DIRS "${QXORM_DIR}/include")
set(POSTGRESQL_INCLUDE_DIRS "${POSTGRESQL_DIR}/include")
if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${PROJECT_NAME}
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES})
else()
    if(ANDROID)
        add_library(${PROJECT_NAME} SHARED
            ${PROJECT_SOURCES})
    else()
        add_executable(${PROJECT_NAME}
          ${PROJECT_SOURCES})
    endif()
endif()
target_include_directories(${PROJECT_NAME} PUBLIC ${QXORM_INCLUDE_DIRS}
                                                  ${POSTGRESQL_INCLUDE_DIRS})
target_compile_definitions(${PROJECT_NAME}
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Sql
    Qt${QT_VERSION_MAJOR}::Network
    ${QXORM_LIB}
    ${POSTGRESQL_LIBS}
    Qaterial)
set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(${PROJECT_NAME})
    qt_finalize_executable(${PROJECT_NAME})
endif()
