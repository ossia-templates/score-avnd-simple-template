cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

if(NOT TARGET score_lib_base)
  include("${SCORE_SOURCE_DIR}/cmake/ScoreExternalAddon.cmake")
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
    MyAvndEffect/MyAvndEffect.hpp
    MyAvndEffect/MyAvndEffectModel.hpp
    MyAvndEffect/MyAvndEffectModel.cpp
    MyAvndEffect/MyAvndEffectUi.hpp
  TARGET my_avnd_effect
  MAIN_CLASS MyAvndEffect
  NAMESPACE Example
)

avnd_score_plugin_finalize(
  BASE_TARGET score_addon_my_avnd_effect
  PLUGIN_VERSION 1
  PLUGIN_UUID "00000000-0000-0000-0000-000000000000"
)
