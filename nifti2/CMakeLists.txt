
add_library(nifti2 nifti2_io.c )
target_link_libraries( nifti2 PUBLIC ${NIFTI_PACKAGE_PREFIX}NIFTI::znz ${NIFTI_SYSTEM_MATH_LIB} )
target_include_directories(nifti2 PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${NIFTI_INSTALL_INCLUDE_DIR}>
        )

if(NIFTI_BUILD_APPLICATIONS)
    add_executable(nifti_tool nifti_tool.c)

    get_rpath() # define message_RPATH
    set_target_properties(nifti_tool
      PROPERTIES
        MACOSX_RPATH ON
        SKIP_BUILD_RPATH OFF
        BUILD_WITH_INSTALL_RPATH OFF
        INSTALL_RPATH "${message_RPATH}"
        INSTALL_RPATH_USE_LINK_PATH ON
      )


    target_link_libraries(nifti_tool PUBLIC nifti2)
    set(NIFTI2_APPS nifti_tool)
endif()

# Set lib version when buildung shared libs.
if(BUILD_SHARED_LIBS)
    set_target_properties(nifti2 PROPERTIES ${NIFTI_LIBRARY_PROPERTIES})
endif()

if(NOT NIFTI_INSTALL_NO_LIBRARIES)
    install(TARGETS nifti2 ${NIFTI2_APPS}
            EXPORT ${NIFTI_INSTALL_EXPORT_NAME}
            RUNTIME DESTINATION ${NIFTI_INSTALL_RUNTIME_DIR} COMPONENT RuntimeLibraries
            LIBRARY DESTINATION ${NIFTI_INSTALL_LIBRARY_DIR} COMPONENT RuntimeLibraries
            ARCHIVE DESTINATION ${NIFTI_INSTALL_LIBRARY_DIR} COMPONENT Development
            INCLUDES DESTINATION ${NIFTI_INSTALL_INCLUDE_DIR}
            )

    # add alias so that linking pattern matches for internal and external
    # cmake code
    add_library(${NIFTI_PACKAGE_PREFIX}NIFTI::nifti2 ALIAS nifti2)
endif()

if(NOT NIFTI_INSTALL_NO_DEVELOPMENT)
    file(GLOB __files "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
    install(FILES ${__files}
            DESTINATION ${NIFTI_INSTALL_INCLUDE_DIR}
            COMPONENT Development)
endif()


if(NIFTI_BUILD_TESTING AND NIFTI_BUILD_APPLICATIONS)
    # in order to decouble nifti2 and niftilib, the nifti1.h file
    # is duplicated here.  The verify_nifti1_headers_are_same test
    # will fail if these two files are not identical.
    if( ( IS_DIRECTORY ${PROJECT_SOURCE_DIR}/nifti2 ) AND (IS_DIRECTORY ${PROJECT_SOURCE_DIR}/niftilib))
        message(STATUS "Testing same")
        add_test(verify_nifti1_headers_are_same ${CMAKE_COMMAND} -E compare_files ${PROJECT_SOURCE_DIR}/nifti2/nifti1.h ${PROJECT_SOURCE_DIR}/niftilib/nifti1.h)
    endif()
    add_executable(clib_02_nifti2 clib_02_nifti2.c)
    target_link_libraries(clib_02_nifti2 PUBLIC nifti2)

    # Do all regression tests
    add_test( NAME nifti_ver COMMAND $<TARGET_FILE:nifti_tool> -nifti_ver)
    add_test( NAME nifti_tool_ver COMMAND $<TARGET_FILE:nifti_tool> -ver)
    add_test( NAME nifti_help COMMAND $<TARGET_FILE:nifti_tool> -help)
    add_test( NAME nifti_nifti_hist COMMAND $<TARGET_FILE:nifti_tool> -nifti_hist)
    add_test( NAME nifti_hist COMMAND $<TARGET_FILE:nifti_tool> -hist)

    add_test( NAME nifti_disp_hdr COMMAND $<TARGET_FILE:nifti_tool> -disp_hdr -infiles ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data/anat0.nii )
    add_test( NAME nifti_disp_nim COMMAND $<TARGET_FILE:nifti_tool> -disp_nim -infiles ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data/anat0.nii )
    add_test( NAME nifti_disp_ext COMMAND $<TARGET_FILE:nifti_tool> -disp_ext -infiles ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data/anat0.nii )
    add_test( NAME nifti_header_check COMMAND $<TARGET_FILE:nifti_tool> -check_hdr -infiles ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data/anat0.nii )
    add_test( NAME nifti_nim_check COMMAND $<TARGET_FILE:nifti_tool> -check_nim -infiles ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data/anat0.nii )
    if(UNIX AND NIFTI_SHELL_SCRIPT_TESTS) # unix needed to run shell scripts
        set(NIFTI_TEST_SCRIPT_DIR ${CMAKE_CURRENT_LIST_DIR}/nifti_regress_test/cmake_testscripts)
        add_test( NAME nifti_modhdr_exts COMMAND sh ${NIFTI_TEST_SCRIPT_DIR}/mod_header_test.sh $<TARGET_FILE:nifti_tool> ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data )
        add_test( NAME nifti_bricks_test COMMAND sh ${NIFTI_TEST_SCRIPT_DIR}/bricks_test.sh $<TARGET_FILE:nifti_tool> ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data )

        add_test( NAME nifti_dci_test COMMAND sh ${NIFTI_TEST_SCRIPT_DIR}/dci_test.sh $<TARGET_FILE:nifti_tool> ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data )
        add_test( NAME nifti_comment_test COMMAND sh ${NIFTI_TEST_SCRIPT_DIR}/comment_test.sh $<TARGET_FILE:nifti_tool> ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data )
        add_test( NAME nifti_dsets_test COMMAND sh ${NIFTI_TEST_SCRIPT_DIR}/dsets_test.sh $<TARGET_FILE:nifti_tool> ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data )
        add_test( NAME nifti_newfiles_test COMMAND sh ${NIFTI_TEST_SCRIPT_DIR}/newfiles_test.sh $<TARGET_FILE:nifti_tool> ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data )

        add_test( NAME nifti_dts_test COMMAND sh ${NIFTI_TEST_SCRIPT_DIR}/dts_test.sh $<TARGET_FILE:nifti_tool> ${fetch_testing_data_SOURCE_DIR}/nifti_regress_data )
        add_test( NAME nifti_mod_hdr2_test COMMAND sh ${NIFTI_TEST_SCRIPT_DIR}/mod_header_2_test.sh $<TARGET_FILE:nifti_tool> ${fetch_testing_data_SOURCE_DIR}/CiftiLib_data )
        set_tests_properties( nifti_dts_test PROPERTIES DEPENDS nifti_bricks_test)


    endif()
endif()
