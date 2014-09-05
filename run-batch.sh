#!/bin/bash

#nohup matlab -nodisplay -nosplash < dagm_process_testing.m > results/run-06_testing_binary_label.out &&
nohup matlab -nodisplay -nosplash < dagm_process.m > results/run-14.out;
nohup matlab -nodisplay -nosplash < dagm_process_other1.m > results/run-15.out;
nohup matlab -nodisplay -nosplash < dagm_process_other2.m > results/run-16.out;
nohup matlab -nodisplay -nosplash < dagm_process_other3.m > results/run-17.out;
nohup matlab -nodisplay -nosplash < dagm_process_other4.m > results/run-18.out;
nohup matlab -nodisplay -nosplash < dagm_process_other5.m > results/run-19.out;

