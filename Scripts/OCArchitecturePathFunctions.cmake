##
# In order to allow simultaneous installation of builds for various configuration and choices,
# OpenCMISS uses an *architecture path* to store produced files, libraries and headers into separate
# directories.
#
# The architecture path is composed of the following elements (in that order)
#
#    :architecture: The system architecture, e.g. :literal:`x86_64_linux` 
#    :toolchain: The toolchain info for the build.
#        This path is composed following the pattern :path:`/<mnemonic>-C<c_version>-<mnemonic>-F<fortran_version>`,
#        where *mnemonic* stands for one of the items below, *c_version* the version of the C compiler and
#        *fortran_version* the version of the Fortran compiler.
# 
#        All the short mnemonics are:
#        
#            :absoft: The Absoft Fortran compiler
#            :borland: The Borland compilers
#            :ccur: The Concurrent Fortran compiler
#            :clang: The CLang toolchain (commonly Mac OS)
#            :cygwin: The CygWin toolchain for Windows environments
#            :gnu: The GNU toolchain
#            :g95: The G95 Fortran compiler
#            :intel: The Intel toolchain
#            :mingw: The MinGW toolchain for Windows environments
#            :msvc: MS Visual Studio compilers
#            :pgi: The Portland Group compilers
#            :watcom: The Watcom toolchain
#            :unknown: Unknown compiler
#    
#    :instrumenation: Any instrumentation systems
#        Otherwise, the path element is skipped.
#    :multithreading: If :var:`OC_USE_MULTITHREADING` is enabled, this segment is :path:`/mt`.
#        Otherwise, the path element is skipped.
#    :mpi: Denotes the used MPI implementation along with the mpi build type.
#        The path element is composed as :path:`/<mnemonic>_<mpi-build-type>`, where *mnemonic*/*mpi-build-type* contains the 
#        lower-case value of the :var:`OPENCMISS_MPI_IMPLEMENTATION`/:var:`OPENCMISS_MPI_BUILD_TYPE` variable, respectively.
#
#        Moreover, a path element :path:`no_mpi` is used for any component that does not use MPI at all.  
#    :buildtype: Path element for the current overall build type determined by :var:`CMAKE_BUILD_TYPE`.
#        This is for single-configuration platforms only - multiconfiguration environments like Visual Studio have their
#        own way of dealing with build types. 
#
# For example, a typical architecture path looks like::
#
#     x86_64_linux/gnu-C4.6-gnu-F4.6/openmpi_release/release
#
# See also: :var:`OPENCMISS_USE_ARCHITECTURE_PATH`

# This function returns two architecture paths, the first for mpi-unaware applications (VARNAME)
# and the second for applications that link against an mpi implementation (VARNAME_MPI)
#
# Requires the extra (=non-cmake default) variables:
# MPI
#
# See also: getSystemPartArchitecturePath, getMPIPartArchitecturePath
function(getArchitecturePath VARNAME VARNAME_MPI)
    
    # Get compiler part
    getCompilerPartArchitecturePath(COMPILER_PART)

    getArchitecturePathGivenCompilerPart(${COMPILER_PART} ARCH_PATH_NOMPI ARCH_PATH_MPI)
 
    # Append to desired variable
    set(${VARNAME_MPI} ${ARCH_PATH_MPI} PARENT_SCOPE)
    set(${VARNAME} ${ARCH_PATH_NOMPI} PARENT_SCOPE)
endfunction()


# This function returns two architecture paths, the first for mpi-unaware applications (VARNAME)
# and the second for applications that link against an mpi implementation (VARNAME_MPI) when the 
# compiler part of the architecture path is given
#
function(getArchitecturePathGivenCompilerPart COMPILER_PART VARNAME VARNAME_MPI)
    # Get the system part
    getSystemPartArchitecturePath(SYSTEM_PART)

    # Don't get compiler part

    # Get instrumentation part
    getInstrumentationPartArchitecturePath(INSTRUMENTATION_PART)

    # Get multithreading part
    getMultithreadingPartArchitecturePath(MULTITHREADING_PART)

    # Get user part
    getUserPartArchitecturePath(USER_PART)

    # Get the MPI Part
    getMPIPartArchitecturePath(MPI_PART)

    set(ARCH_PATH_MPI /${SYSTEM_PART}/${COMPILER_PART}${INSTRUMENTATION_PART}${MULTITHREADING_PART}${USER_PART}/${MPI_PART})
    set(ARCH_PATH_NOMPI /${SYSTEM_PART}/${COMPILER_PART}${INSTRUMENTATION_PART}${MULTITHREADING_PART}${USER_PART}/no_mpi)

    # Append to desired variable
    set(${VARNAME_MPI} ${ARCH_PATH_MPI} PARENT_SCOPE)
    set(${VARNAME} ${ARCH_PATH_NOMPI} PARENT_SCOPE)
endfunction()

# This function assembles the MPI part of the architecture path.
# This part is made up of [OPENCMISS_MPI_IMPLEMENTATION][OPENCMISS_MPI_BUILD_TYPE]
# if building our own MPI otherwise it is made up of
# [OPENCMISS_MPI]system.
function(getMPIPartArchitecturePath VARNAME)
    # MPI version information
    if (OPENCMISS_MPI STREQUAL none)
        SET(MPI_PART "no_mpi")
    else()
        # Add the build type of MPI to the architecture path - we obtain different libraries
        # for different mpi build types
        if (OPENCMISS_BUILD_OWN_MPI)
            string(TOLOWER "${OPENCMISS_MPI_BUILD_TYPE}" MPI_BUILD_TYPE_LOWER)
        else ()
            set(MPI_BUILD_TYPE_LOWER system)
        endif ()
        set(MPI_PART ${OPENCMISS_MPI_IMPLEMENTATION}_${MPI_BUILD_TYPE_LOWER})
    endif()

    # Append to desired variable
    set(${VARNAME} ${MPI_PART} PARENT_SCOPE)
endfunction()

# This function assembles the instrumentation part of the architecture path.
# This part is made up of [INSTRUMENTATION]
#
function(getMultithreadingPartArchitecturePath VARNAME)
    # Multithreading
    if (OC_MULTITHREADING)
        SET(MULTITHREAD_PART /mt)
    endif()
    
    # Append to desired variable
    set(${VARNAME} "${MULTITHREAD_PART}" PARENT_SCOPE)
endfunction()

# This function assembles the instrumentation part of the architecture path.
# This part is made up of [INSTRUMENTATION]
#
function(getUserPartArchitecturePath VARNAME)# User part
    if (OPENCMISS_USER_PART_ARCHITECTURE_PATH)
        file(TO_CMAKE_PATH OPENCMISS_USER_PART_ARCHITECTURE_PATH_WITH_SLASH ${OPENCMISS_USER_PART_ARCHITECTURE_PATH})
        if (NOT "OPENCMISS_USER_PART_ARCHITECTURE_PATH_WITH_SLASH" MATCHES "^/")
            set(OPENCMISS_USER_PART_ARCHITECTURE_PATH_WITH_SLASH /${OPENCMISS_USER_PART_ARCHITECTURE_PATH_WITH_SLASH})
        endif ()
    endif ()

    # Append to desired variable
    set(${VARNAME} "${OPENCMISS_USER_PART_ARCHITECTURE_PATH_WITH_SLASH}" PARENT_SCOPE)
endfunction()

# This function assembles the instrumentation part of the architecture path.
# This part is made up of [INSTRUMENTATION]
#
function(getInstrumentationPartArchitecturePath VARNAME)

    # Instrumentation
    if ("${OPENCMISS_INSTRUMENTATION}" STREQUAL "scorep")
        set(INSTRUMENTATION_PART /scorep)
    elseif ("${OPENCMISS_INSTRUMENTATION}" STREQUAL "vtune")
        set(INSTRUMENTATION_PART /vtune)
    elseif ("${OPENCMISS_INSTRUMENTATION}" STREQUAL "gprof")
        set(INSTRUMENTATION_PART /gprof)
    elseif ("${OPENCMISS_INSTRUMENTATION}" STREQUAL "none")
        set(INSTRUMENTATION_PART) # Do nothing
    else ()
        message(STATUS "Unknown instrumentation option. Ignoring.")
    endif ()
    
    # Append to desired variable
    set(${VARNAME} "${INSTRUMENTATION_PART}" PARENT_SCOPE)
endfunction()

# This function assembles the system part of the architecture path
# This part is made up of [SYSTEM_NAME][SYSTEM_PROCESSOR]
#
function(getSystemPartArchitecturePath VARNAME)
    
    # Architecture/System
    string(TOLOWER ${CMAKE_SYSTEM_NAME} CMAKE_SYSTEM_NAME_LOWER)
    set(ARCHPATH ${CMAKE_SYSTEM_PROCESSOR}_${CMAKE_SYSTEM_NAME_LOWER})
    
    # Bit/Adressing bandwidth
    #if (ABI)
    #    SET(ARCHPATH ${ARCHPATH}/${ABI}bit)
    #endif()
    
    # Append to desired variable
    set(${VARNAME} ${ARCHPATH} PARENT_SCOPE)
endfunction()

function(getCompilerPartArchitecturePath VARNAME)
    # Form the C compiler part
    # Get the C compiler name
    if(MINGW)
	set(_C_COMP "mingw" )
    elseif(MSYS )
	set(_C_COMP "msys" )
    elseif(BORLAND )
	set(_C_COMP "borland" )
    elseif(WATCOM )
	set(_C_COMP "watcom" )
    elseif(MSVC OR MSVC_IDE OR MSVC60 OR MSVC70 OR MSVC71 OR MSVC80 OR CMAKE_COMPILER_2005 OR MSVC90 )
	set(_C_COMP "msvc" )
    elseif(CMAKE_COMPILER_IS_GNUCC)
	set(_C_COMP "gnu")
    elseif(CMAKE_C_COMPILER_ID MATCHES Clang)
	set(_C_COMP "clang")
    elseif(CMAKE_C_COMPILER_ID MATCHES Intel 
	   OR CMAKE_CXX_COMPILER_ID MATCHES Intel)
	set(_C_COMP "intel")
    elseif(CMAKE_C_COMPILER_ID MATCHES PGI)
	set(_C_COMP "pgi")
    elseif( CYGWIN )
	set(_C_COMP "cygwin")
    else()
        set(_C_COMP "unknown")       
    endif()
	
    # Get compiler major + minor versions
    set(_COMPILER_VERSION_REGEX "^[0-9]+\\.[0-9]+")
    string(REGEX MATCH ${_COMPILER_VERSION_REGEX}
       _C_COMPILER_VERSION_MM "${CMAKE_C_COMPILER_VERSION}")
    # Form C part
    set(_C_PART "${_C_COMP}-C${_C_COMPILER_VERSION_MM}")
 
    # Also for the fortran compiler (if exists)
    set(_FORTRAN_PART "")
    if (CMAKE_Fortran_COMPILER_ID)
       # Get the Fortran compiler name
       if(CMAKE_Fortran_COMPILER_ID MATCHES Absoft)
	   set(_Fortran_COMP "absoft")
       elseif(CMAKE_Fortran_COMPILER_ID MATCHES Ccur)
	   set(_Fortran_COMP "ccur")
       elseif(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
	   set(_Fortran_COMP "gnu")
       elseif(CMAKE_Fortran_COMPILER_ID MATCHES G95)
           set(_Fortran_COMP "g95")
       elseif(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
           set(_Fortran_COMP "intel")
       elseif(CMAKE_Fortran_COMPILER_ID MATCHES PGI)
           set(_Fortran_COMP "pgi")
       else()
           set(_Fortran_COMP "unknown")       
       endif()
       string(REGEX MATCH ${_COMPILER_VERSION_REGEX}
           _Fortran_COMPILER_VERSION_MM "${CMAKE_Fortran_COMPILER_VERSION}")
       set(_FORTRAN_PART "-${_Fortran_COMP}-F${_Fortran_COMPILER_VERSION_MM}")
    endif()
    
    # Combine C and Fortran part into e.g. gnu-C4.8-intel-F4.5
    set(${VARNAME} "${_C_PART}${_FORTRAN_PART}" PARENT_SCOPE)
endfunction()

# Returns the build type arch path element.
# useful only for single-configuration builds, '.' otherwise.
function(getBuildTypePathElem VARNAME)
    # Build type
    if (OPENCMISS_HAVE_MULTICONFIG_ENV)
        SET(BUILDTYPEEXTRA .)
    else()
        STRING(TOLOWER ${CMAKE_BUILD_TYPE} buildtype)
        SET(BUILDTYPEEXTRA ${buildtype})
    endif()
    SET(${VARNAME} ${BUILDTYPEEXTRA} PARENT_SCOPE)
endfunction()
