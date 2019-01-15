add_executable(parent_exe parent_project_exe.c)
target_link_libraries(parent_exe PUBLIC ${SILLYDEMO_PACKAGE_PREFIX}NIFTI::nifticdf)
install(TARGETS parent_exe
  EXPORT ${SILLYDEMO_TARGETS}
  DESTINATION ${SILLYDEMO_INSTALL_RUNTIME_DIR})
