#!/usr/bin/env python3 
# -*- coding: utf-8 -*-
# ===========================================================================
# Created By  : Yuki Ishikawa
# Created Date: 2023-11-18
# ===========================================================================
"""
Class to store and fetch the assimilation settings
"""
# ===========================================================================
# Class
# ===========================================================================
class SettingBook:
    def __init__(self):
        self.settings = {}
    
    def add_setting(self, key, value):
        self.settings[key] = value