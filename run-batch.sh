#!/bin/bash

#nohup matlab -nodisplay -nosplash < dagm_process_testing.m > results/run-06_testing_binary_label.out &&
nohup matlab -nodisplay -nosplash < dagm_process.m > results/run-e-1.log;
nohup matlab -nodisplay -nosplash < dagm_process_other1.m > results/run-e-2.log;
nohup matlab -nodisplay -nosplash < dagm_process_other2.m > results/run-e-3.log;
nohup matlab -nodisplay -nosplash < dagm_process_other3.m > results/run-e-4.log;
nohup matlab -nodisplay -nosplash < dagm_process_other4.m > results/run-e-5.log;
nohup matlab -nodisplay -nosplash < dagm_process_other5.m > results/run-e-6.log;

