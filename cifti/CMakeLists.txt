include(FindEXPAT)
add_library(cifti afni_xml.c afni_xml_io.c )
target_link_libraries( cifti PUBLIC EXPAT::EXPAT ${NIFTI_PACKAGE_PREFIX}NIFTI::nifti2)
target_include_directories(cifti PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${NIFTI_INSTALL_INCLUDE_DIR}>
        )

if(NIFTI_BUILD_APPLICATIONS)
  add_executable(afni_xml_tool afni_xml_tool.c)
  target_link_libraries(afni_xml_tool PUBLIC cifti)
  add_executable(cifti_tool cifti_tool.c)
  target_link_libraries(cifti_tool PUBLIC cifti)

  set(CIFTI_APPS afni_xml_tool cifti_tool)
endif()
# Set lib version when buildung shared libs.
if(BUILD_SHARED_LIBS)
    set_target_properties(cifti PROPERTIES ${NIFTI_LIBRARY_PROPERTIES})
endif()

if(NOT NIFTI_INSTALL_NO_LIBRARIES)
    install(TARGETS cifti ${CIFTI_APPS}
            EXPORT NIFTITargets
            RUNTIME DESTINATION ${NIFTI_INSTALL_RUNTIME_DIR} COMPONENT RuntimeLibraries
            LIBRARY DESTINATION ${NIFTI_INSTALL_LIBRARY_DIR} COMPONENT RuntimeLibraries
            ARCHIVE DESTINATION ${NIFTI_INSTALL_LIBRARY_DIR} COMPONENT Development
            INCLUDES DESTINATION ${NIFTI_INSTALL_INCLUDE_DIR}
            )
    add_library(${NIFTI_PACKAGE_PREFIX}NIFTI::cifti ALIAS cifti)
endif()

if(NOT NIFTI_INSTALL_NO_DEVELOPMENT)
    file(GLOB __files "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
    install(FILES ${__files}
            DESTINATION ${NIFTI_INSTALL_INCLUDE_DIR}
            COMPONENT Development)
endif()
