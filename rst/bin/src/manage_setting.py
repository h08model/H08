#!/usr/bin/env python3 
# -*- coding: utf-8 -*-
# ===========================================================================
# Created By  : Yuki Ishikawa
# Created Date: 2023-11-20
# ===========================================================================
"""
Program to manage simulation settings
"""
# ===========================================================================
# Import
# ===========================================================================
import pandas as pd

from src.initial_setting import initial_setting
# ===========================================================================
# Class
# ===========================================================================
class SettingManager:
    def __init__(self):
        self.settings = initial_setting()

    def subprocess_input(self, current_bgn_time, current_end_time):
        run_input = self.settings['run_cmd'].copy()
        run_input.append(self.settings['prj'])                # PRJ
        run_input.append(self.settings['run'])                # RUN
        run_input.append(str(self.settings['bgn_time'].year)) # YEARMIN
        run_input.append(str(self.settings['end_time'].year)) # YEARMAX
        run_input.append(self.settings['prjmet'])             # PRJMET
        run_input.append(self.settings['runmet'])             # RUNMET
        run_input.append(str(self.settings['flag_spn']))      # SPNFLG
        run_input.append(str(self.settings['flag_rstbgn']))   # RSTBGNFLG
        run_input.append(str(self.settings['flag_rstend']))   # RSTENDFLG
        run_input.extend(current_bgn_time.strftime("%Y %-m %-d").split(' ')) #YEAR, MON, DAY of RSTBGN
        run_input.extend(current_end_time.strftime("%Y %-m %-d").split(' ')) #YEAR, MON, DAY of RSTEND         
        return run_input
    
