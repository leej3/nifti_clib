add_library(fslio fslio.c )
target_link_libraries( fslio PUBLIC ${NIFTI_PACKAGE_PREFIX}NIFTI::niftiio)
target_include_directories(fslio PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${NIFTI_INSTALL_INCLUDE_DIR}>
        )

# Set lib version when buildung shared libs.
if(BUILD_SHARED_LIBS)
  set_target_properties(fslio PROPERTIES ${NIFTI_LIBRARY_PROPERTIES})
endif()

if(NOT NIFTI_INSTALL_NO_LIBRARIES)
  install(TARGETS fslio
          EXPORT ${NIFTI_INSTALL_EXPORT_NAME}
          RUNTIME DESTINATION ${NIFTI_INSTALL_RUNTIME_DIR} COMPONENT RuntimeLibraries
          LIBRARY DESTINATION ${NIFTI_INSTALL_LIBRARY_DIR} COMPONENT RuntimeLibraries
          ARCHIVE DESTINATION ${NIFTI_INSTALL_LIBRARY_DIR} COMPONENT Development
          INCLUDES DESTINATION ${NIFTI_INSTALL_INCLUDE_DIR}
          )
  add_library(${NIFTI_PACKAGE_PREFIX}NIFTI::fslio ALIAS fslio)
endif()

if(NOT NIFTI_INSTALL_NO_DEVELOPMENT)
  file(GLOB __files "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
  install(FILES ${__files}
    DESTINATION ${NIFTI_INSTALL_INCLUDE_DIR}
    COMPONENT Development)
endif()

if(NIFTI_BUILD_APPLICATIONS)
  add_subdirectory(examples)
endif()
