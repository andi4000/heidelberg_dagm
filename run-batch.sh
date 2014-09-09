#!/bin/bash

#nohup matlab -nodisplay -nosplash < dagm_process_testing.m > results/run-06_testing_binary_label.out &&
nohup matlab -nodisplay -nosplash < dagm_process.m > results/run-20.out;
nohup matlab -nodisplay -nosplash < dagm_process_other1.m > results/run-21.out;
nohup matlab -nodisplay -nosplash < dagm_process_other2.m > results/run-22.out;
nohup matlab -nodisplay -nosplash < dagm_process_other3.m > results/run-23.out;
nohup matlab -nodisplay -nosplash < dagm_process_other4.m > results/run-24.out;
#nohup matlab -nodisplay -nosplash < dagm_process_other5.m > results/run-25.out;

