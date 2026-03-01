#!/usr/bin/env python3 
# -*- coding: utf-8 -*-
# ===========================================================================
# Created By  : Yuki Ishikawa
# Created Date: 2023-11-20
# ===========================================================================
"""
Class to run simulation with restart.
"""
# ===========================================================================
# Import
# ===========================================================================
import datetime
import os
import subprocess
import sys
import time
from multiprocessing import Pool

# from src.initial_setting import initial_setting
from src.manage_setting import SettingManager

# ===========================================================================
# Class
# ===========================================================================
class H08Run:
    def __init__(self):
        self.sm = SettingManager()
        ## Move to the directory to run H08
        os.chdir(self.sm.settings['h08_run_dir'])
        print(os.getcwd())
    
    def run_single(self):
        ## Get the simulation period and interval
        bgn_time = self.sm.settings['bgn_time']
        end_time = self.sm.settings['end_time']

        ## Run a single H08 simulation
        run_input = self.sm.subprocess_input(bgn_time, end_time)
        subprocess.run(run_input)
        
        return None
    
    