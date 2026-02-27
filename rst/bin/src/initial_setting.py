#!/usr/bin/env python3 
# -*- coding: utf-8 -*-
# ===========================================================================
# Created By  : Yuki Ishikawa
# Created Date: 2023-11-20
# ===========================================================================
"""
Program to read config file and store simulation settings
"""
# ===========================================================================
# Import
# ===========================================================================
import configparser
import datetime
import numpy as np
import os
import sys

if __name__ == "__main__":
    from settings_book import SettingBook
else:
    from src.settings_book import SettingBook

# ===========================================================================
# Function
# ===========================================================================
def initial_setting():
    setting = SettingBook()
    setting.add_setting('work_dir', os.getcwd())

    # -----------------------------------------------------------------------
    # Read general settings for simulation
    # -----------------------------------------------------------------------
    config = configparser.ConfigParser()
    config.optionxform = str
    config.read("../cfg/restart_settings.conf", encoding="utf-8")

    ## H08 run directory
    h08_run_dir = config['GeneralSettings']['h08_run_dir']
    os.chdir(h08_run_dir)
    setting.add_setting('h08_run_dir', os.getcwd())

    ## Command to run H08
    os.chdir(setting.settings['work_dir'])
    run_cmd = config['GeneralSettings']['run_cmd']
    setting.add_setting('run_cmd', run_cmd.split(' '))

    ## Simulation name
    prj = config['GeneralSettings']['prj']
    setting.add_setting('prj', prj)
    run = config['GeneralSettings']['run']
    setting.add_setting('run', run)
    prjmet = config['GeneralSettings']['prjmet']
    setting.add_setting('prjmet', prjmet)
    runmet = config['GeneralSettings']['runmet']
    setting.add_setting('runmet', runmet)

    ## Simulation period
    yearbgn = int(config['GeneralSettings']['yearbgn'])
    monthbgn = int(config['GeneralSettings']['monthbgn'])
    daybgn = int(config['GeneralSettings']['daybgn'])
    bgn_time = datetime.datetime(year=yearbgn, month=monthbgn, day=daybgn)
    setting.add_setting('bgn_time', bgn_time)
    yearend = int(config['GeneralSettings']['yearend'])
    monthend = int(config['GeneralSettings']['monthend'])
    dayend = int(config['GeneralSettings']['dayend'])
    end_time = datetime.datetime(year=yearend, month=monthend, day=dayend)
    setting.add_setting('end_time', end_time)
    
    ## Spin-up flag
    flag_spn = int(config['GeneralSettings']['flag_spn'])
    setting.add_setting('flag_spn', flag_spn)

    ## Restart flags
    if flag_spn == 1:
        setting.add_setting('flag_rstbgn', 1)
    else:
        setting.add_setting('flag_rstbgn', 0)
    setting.add_setting('flag_rstend', 1)

    return setting.settings

# ===========================================================================
# Main
# ===========================================================================
if __name__ == "__main__":
    settings = initial_setting()
    print(settings)