
if (OPENCMISS_INSTRUMENTATION)
    STRING(TOLOWER "${OPENCMISS_INSTRUMENTATION}" OPENCMISS_INSTRUMENTATION)
    SET(OPENCMISS_INSTRUMENTATION ${OPENCMISS_INSTRUMENTATION} CACHE STRING "Instrumentation to be added" FORCE)
    if (OPENCMISS_INSTRUMENTATION STREQUAL "scorep")
#        SET(OC_INSTRUMENTATION scorep)
	# Reset compiler names to their scorep wrapper compiler name
	if(DEFINED CMAKE_C_COMPILER)
	  string(CONCAT CMAKE_C_COMPILER "scorep-" "${CMAKE_C_COMPILER}")
	endif()
	if(DEFINED CMAKE_CXX_COMPILER)
	  string(CONCAT CMAKE_CXX_COMPILER "scorep-" "${CMAKE_CXX_COMPILER}")
	endif()
	if(DEFINED CMAKE_Fortran_COMPILER)
	  string(CONCAT CMAKE_Fortran_COMPILER "scorep-" "${CMAKE_Fortran_COMPILER}")
	endif()
    elseif (OPENCMISS_INSTRUMENTATION STREQUAL "vtune")
#        if(TOOLCHAIN STREQUAL "intel")
        # Do nothing
#          SET(OC_INSTRUMENTATION vtune)
#	else()
#          message(WARNING "Can only use vtune instrumentation with an Intel toolchain. Proceeding with no instrumentation.")
#        endif()
    elseif (OPENCMISS_INSTRUMENTATION STREQUAL "gprof")
        # Do nothing
#          SET(OC_INSTRUMENTATION gprof)
    elseif (OPENCMISS_INSTRUMENTATION STREQUAL "none")
        # Do nothing
#
    else()
        message(WARNING "Unknown instrumentation: ${OPENCMISS_INSTRUMENTATION}. Proceeding with no instrumentation.")
    endif()
endif()

