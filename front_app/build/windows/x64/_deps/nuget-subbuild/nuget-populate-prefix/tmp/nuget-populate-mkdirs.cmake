# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-src"
  "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-build"
  "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix"
  "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/tmp"
  "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp"
  "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src"
  "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp"
)

set(configSubDirs Debug)
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "H:/develop_tool/MyProject/flutter_application/front_app/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
