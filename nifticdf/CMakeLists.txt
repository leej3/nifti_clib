
add_library(nifticdf nifticdf.c )
target_link_libraries(nifticdf PRIVATE ${NIFTI_PACKAGE_PREFIX}NIFTI::niftiio)
target_include_directories(nifticdf PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${NIFTI_INSTALL_INCLUDE_DIR}>
        )
if(NIFTI_BUILD_APPLICATIONS)
  add_executable(nifti_stats nifti_stats.c)
  target_link_libraries( nifti_stats PUBLIC nifticdf ${NIFTI_PACKAGE_PREFIX}NIFTI::niftiio )
  set(NIFTICDF_APPS nifti_stats)
endif()

if(BUILD_SHARED_LIBS)
  set_target_properties(nifticdf PROPERTIES ${NIFTI_LIBRARY_PROPERTIES})
endif()


if(NOT NIFTI_INSTALL_NO_LIBRARIES)
  install(TARGETS nifticdf ${NIFTICDF_APPS}
          EXPORT NIFTITargets
          RUNTIME DESTINATION ${NIFTI_INSTALL_RUNTIME_DIR} COMPONENT RuntimeLibraries
          LIBRARY DESTINATION ${NIFTI_INSTALL_LIBRARY_DIR} COMPONENT RuntimeLibraries
          ARCHIVE DESTINATION ${NIFTI_INSTALL_LIBRARY_DIR} COMPONENT Development
          INCLUDES DESTINATION ${NIFTI_INSTALL_INCLUDE_DIR}
          )
  add_library(${NIFTI_PACKAGE_PREFIX}NIFTI::nifticdf ALIAS nifticdf)
endif()

if(NOT NIFTI_INSTALL_NO_DEVELOPMENT)
  file(GLOB __files "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
  install(FILES ${__files}
    DESTINATION ${NIFTI_INSTALL_INCLUDE_DIR}
    COMPONENT Development)
endif()

if(NIFTI_BUILD_TESTING AND NIFTI_BUILD_APPLICATIONS)
  foreach(DISTRIBUTION CORREL TTEST FTEST ZSCORE CHISQ BETA BINOM GAMMA POISSON NORMAL FTEST_NONC CHISQ_NONC LOGISTIC LAPLACE UNIFORM TTEST_NONC WEIBULL CHI INVGAUSS EXTVAL PVAL LOGPVAL LOG10PVAL )
    add_test( NAME nifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> 0:4:1 ${DISTRIBUTION})
    add_test( NAME qnifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -q 0:4:1 ${DISTRIBUTION})
    add_test( NAME q1nifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -q 0:4:1 ${DISTRIBUTION} 1 1 1)
    add_test( NAME dnifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -d 0:4:1 ${DISTRIBUTION})
    add_test( NAME d1nifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -d 0:4:1 ${DISTRIBUTION} 1 1 1)
    add_test( NAME 1nifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -1 0:4:1 ${DISTRIBUTION})
    add_test( NAME 11nifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -1 0:4:1 ${DISTRIBUTION} 1 1 1)
    add_test( NAME znifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -z 0:4:1 ${DISTRIBUTION})
    add_test( NAME z1nifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -z 0:4:1 ${DISTRIBUTION} 1 1 1)
    add_test( NAME hnifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -h 0:4:1 ${DISTRIBUTION})
    add_test( NAME h1nifti_stats_${DISTRIBUTION}_test COMMAND $<TARGET_FILE:nifti_stats> -h 0:4:1 ${DISTRIBUTION} 1 1 1)
  endforeach()
endif()
