#!/bin/bash

#nohup matlab -nodisplay -nosplash < dagm_process_testing.m > results/run-06_testing_binary_label.out &&
nohup matlab -nodisplay -nosplash < dagm_process.m > results/run-07.out;
nohup matlab -nodisplay -nosplash < dagm_process_other1.m > results/run-08.out;
nohup matlab -nodisplay -nosplash < dagm_process_other2.m > results/run-09.out;
nohup matlab -nodisplay -nosplash < dagm_process_other3.m > results/run-10.out;
nohup matlab -nodisplay -nosplash < dagm_process_other4.m > results/run-11.out;
nohup matlab -nodisplay -nosplash < dagm_process_other5.m > results/run-12.out;

