cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "receive_sharing_intent")
project(${PROJECT_NAME} LANGUAGES CXX)

# Apply the standard setting for Flutter plugin build
set(PLUGIN_NAME "${PROJECT_NAME}_plugin")

add_library(${PLUGIN_NAME} SHARED
  "receive_sharing_intent_plugin.cpp"
)

# Use same include dirs as other plugins
target_include_directories(${PLUGIN_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_link_libraries(${PLUGIN_NAME} PRIVATE flutter::flutter)

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden
  VISIBILITY_INLINES_HIDDEN 1
)

# List of absolute paths to libraries that should be bundled with the plugin.
set(receive_sharing_intent_bundled_libraries
  ""
)
