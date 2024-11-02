cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

if(NOT TARGET score_lib_base)
  include(ScoreExternalAddon)
endif()

if(NOT TARGET score_plugin_avnd)
  return()
endif()

project(score_addon_my_avnd_effect LANGUAGES CXX)

avnd_score_plugin_init(
  BASE_TARGET score_addon_my_avnd_effect
)

avnd_score_plugin_add(
  BASE_TARGET score_addon_my_avnd_effect
  SOURCES
    MyAvndEffect/MyAvndEffectModel.cppm
  TARGET my_avnd_effect
  MAIN_CLASS MyAvndEffect
  NAMESPACE Example
  MODULE
)

avnd_score_plugin_finalize(
  MODULE
  BASE_TARGET score_addon_my_avnd_effect
  PLUGIN_VERSION 1
  PLUGIN_UUID "00000000-0000-0000-0000-000000000000"
)

target_link_libraries(score_addon_my_avnd_effect PUBLIC avnd_halp_module)
