# ==============================
# Build configuration
# ==============================

# Precision to build (if applicable)
# Valid choices are s,d,c,z and any combinations.
# s: Single / float precision
# d: Double precision
# c: Complex / float precision
# z: Complex / double precision
set(BUILD_PRECISION sd CACHE STRING "Build precisions for OpenCMISS components. Choose any of [sdcz]")

# The integer types that can be used (if applicable)
# Used only by PASTIX yet
set(INT_TYPE int32 CACHE STRING "OpenCMISS integer type (only used by PASTIX yet)")

# Also build tests?
option(BUILD_TESTS "Build OpenCMISS(-components) tests" OFF)

option(PARALLEL_BUILDS "Use multithreading (-jN etc) for builds" ON)

# Type of libraries to build
# The default is static for all dependencies and shared for main components (iron and zinc)
# If set to yes, every component will 
option(BUILD_SHARED_LIBS "Build shared libraries within/for every component" NO)

# Have the build system wrap the builds of component into log files.
# Selecting NO will directly print the build process to the standard output.
set(OCM_CREATE_LOGS YES)

# Debug postfix
set(CMAKE_DEBUG_POSTFIX d CACHE STRING "Debug postfix for library names of DEBUG-builds")

# ==============================
# Compilers
# ==============================
# Flag for DEBUG configuration builds only!
SET(OCM_WARN_ALL YES)
SET(OCM_CHECK_ALL YES)

# ==============================
# Multithreading
# This controls openmp/OpenAcc
# ==============================
option(OCM_USE_MT "Use multithreading in OpenCMISS (where applicable)" NO)

# ==============================
# Defaults for all dependencies
# ==============================
# This is changeable in the OpenCMISSLocalConfig file
FOREACH(OCM_DEP ${OPENCMISS_COMPONENTS})
    LIST(FIND OPENCMISS_COMPONENTS_DISABLED_BY_DEFAULT ${OCM_DEP} _COMP_POS)
    set(_VALUE YES)
    if (_COMP_POS GREATER -1)
        set(_VALUE NO)
    endif()
    # Use everything but the components in OPENCMISS_COMPONENTS_DISABLED_BY_DEFAULT
    option(OCM_USE_${OCM_DEP} "Use OpenCMISS component ${OCM_DEP}" ${_VALUE})
    
    # Look for some components on the system first before building
    LIST(FIND OPENCMISS_COMPONENTS_SYSTEM_BY_DEFAULT ${OCM_DEP} _COMP_POS)
    SET(_VALUE NO)
    if (_COMP_POS GREATER -1)
        SET(_VALUE YES)
    endif()
    option(OCM_SYSTEM_${OCM_DEP} "Enable local system search for ${OCM_DEP}" ${_VALUE})
    # Initialize the default: static build for all components
    option(${OCM_DEP}_SHARED "Build ${OCM_DEP} with shared libraries" NO)
ENDFOREACH()

# Main version
SET(OPENCMISS_VERSION 1.0)

# Component versions
SET(BLAS_VERSION 3.5.0)
SET(HYPRE_VERSION 2.10.0) # Alternatives: 2.9.0
SET(LAPACK_VERSION 3.5.0)
SET(LIBCELLML_VERSION 1.0)
SET(METIS_VERSION 5.1)
SET(MUMPS_VERSION 5.0.0) # Alternatives: 4.10.0
SET(PASTIX_VERSION 5.2.2.16)
SET(PARMETIS_VERSION 4.0.3)
SET(PETSC_VERSION 3.5)
SET(PLAPACK_VERSION 3.0)
SET(PTSCOTCH_VERSION 6.0.3)
SET(SCALAPACK_VERSION 2.8)
SET(SCOTCH_VERSION 6.0.3)
SET(SLEPC_VERSION 3.5)
SET(SOWING_VERSION 1.1.16)
SET(SUITESPARSE_VERSION 4.4.0)
SET(SUNDIALS_VERSION 2.5)
SET(SUPERLU_VERSION 4.3)
SET(SUPERLU_DIST_VERSION 3.3)
SET(ZLIB_VERSION 1.2.3)
SET(BZIP2_VERSION 1.0.6) # Alternatives: 1.0.5
SET(FIELDML-API_VERSION 0.5.0)
SET(LIBXML2_VERSION 2.7.6)
SET(LLVM_VERSION 3.4)
SET(GTEST_VERSION 1.7.0)
SET(SZIP_VERSION 2.1)
set(HDF5_VERSION 1.8.14)
set(JPEG_VERSION 6.0.0)
set(NETGEN_VERSION 4.9.11)
set(FREETYPE_VERSION 2.4.10)
set(FTGL_VERSION 2.1.3)
set(GLEW_VERSION 1.5.5)
set(OPTPP_VERSION 681)
set(LIBPNG_VERSION 1.5.2)
set(TIFF_VERSION 3.8.2)
set(GDCM_VERSION 2.0.12)
set(IMAGEMAGICK_VERSION 6.7.0.8)
set(ITK_VERSION 3.20.0)

# MPI
SET(OPENMPI_VERSION 1.8.4)
SET(MPICH_VERSION 3.1.3)
SET(MVAPICH2_VERSION 2.1)
# Cellml
SET(CELLML_VERSION 1.0) # any will do, not used
SET(CSIM_VERSION 1.0)

# will be "master" finally
SET(IRON_BRANCH iron)
# Needs to be here until the repo's name is "iron", then it's compiled automatically (see Iron.cmake/BuildMacros)
SET(IRON_REPO https://github.com/rondiplomatico/iron)
set(IRON_SHARED YES)
set(ZINC_SHARED YES)

SET(EXAMPLES_REPO https://github.com/rondiplomatico/examples)
set(EXAMPLES_BRANCH cmake)

SET(ZINC_BRANCH master)
SET(ZINC_REPO https://github.com/hsorby/zinc)

# ==========================================================================================
# Single module configuration
#
# These flags only apply if the corresponding package is build
# by the OpenCMISS Dependencies system. The packages themselves will then search for the
# appropriate consumed packages. No checks are performed on whether the consumed packages
# will also be build by us or not, as they might be provided externally.
#
# To be safe: E.g. if you wanted to use MUMPS with SCOTCH, also set OCM_USE_SCOTCH=YES so that
# the build system ensures that SCOTCH will be available.
# ==========================================================================================
SET(MUMPS_WITH_SCOTCH NO)
SET(MUMPS_WITH_PTSCOTCH YES)
SET(MUMPS_WITH_METIS NO)
SET(MUMPS_WITH_PARMETIS YES)

SET(SUNDIALS_WITH_LAPACK YES)

SET(SCOTCH_USE_THREADS YES)
SET(SCOTCH_WITH_ZLIB YES)
SET(SCOTCH_WITH_BZIP2 YES)

SET(SUPERLU_DIST_WITH_PARMETIS YES)

SET(PASTIX_USE_THREADS YES)
SET(PASTIX_USE_METIS YES)
SET(PASTIX_USE_PTSCOTCH YES)

set(HDF5_WITH_MPI NO)
set(HDF5_WITH_SZIP YES)
set(HDF5_WITH_ZLIB YES)

set(FIELDML-API_WITH_HDF5 NO)
set(FIELDML-API_WITH_JAVA_BINDINGS NO)
set(FIELDML-API_WITH_FORTRAN_BINDINGS YES)

SET(IRON_WITH_CELLML YES)
SET(IRON_WITH_FIELDML NO)
SET(IRON_WITH_HYPRE YES)
SET(IRON_WITH_SUNDIALS YES)
SET(IRON_WITH_MUMPS YES)
SET(IRON_WITH_SCALAPACK YES)
SET(IRON_WITH_PETSC YES)

SET(LIBXML2_WITH_ZLIB YES)
