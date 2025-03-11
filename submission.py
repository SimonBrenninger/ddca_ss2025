#!/bin/env python3

import json
import os
import sys
import pathlib
import textwrap
import hashlib

RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
RESET = "\033[0m"

slog = None

def init_slog(path):
	global slog
	slog = open(path, "w")

def error(msg: str):
	print(f"{RED}Error: {msg}{RESET}")
	slog.write(f"Error: {msg}\n")
	exit(1)

def warning(msg: str):
	print(f"{YELLOW}Warning: {msg}{RESET}")
	slog.write(f"Warning: {msg}\n")

def message(msg: str):
	print(msg)
	slog.write(f"{msg}\n")

def usage():
	print(textwrap.dedent("""\
		HWMod Homework Submission Script

		./submission.py CHAPTER TASKS ...

		Usage examples:
		  * Submit the tasks 'alu' and 'sram' of level 1:
		    ./submission.py level1 alu sram
		  * Additional '/' charactars in the task names are ignored, so is the prefix
		    'CHAPTER/'. Hence, you can also run:
		    ./submission.py level1 level1/alu/ level1/sram/
		  * Submit all tasks of level 1:
		    ./submission.py level1 -a"""))
		#--------|---------|---------|---------|---------|---------|---------|---------|


def hash_file_digest(file_path: pathlib.Path, algorithm="sha256", chunk_size=8192) -> str:
	try:
		hasher = hashlib.new(algorithm)
	except ValueError as e:
		raise ValueError(f"Invalid algorithm '{algorithm}'.") from e
	with open(file_path, "rb") as f:
		while chunk := f.read(chunk_size):
			hasher.update(chunk)
	return hasher.hexdigest()


def create_submission_archive(level: str, tasks: list[str]):
	level_dir = pathlib.Path(level).absolute()
	level = level_dir.name
	init_slog(f"{level_dir}/submission.log")
	slog.write(f"tasks to submit: {tasks}\n")

	if len(tasks) == 1 and tasks[0] == "-a":
		tasks = [name for name in os.listdir(level_dir) if os.path.isdir(os.path.join(level_dir, name))]
	else:
		tasks = [x.strip("/").removeprefix(f"{level}/") for x in tasks]

	total_points = 0

	# check submitted tasks
	for task in tasks:
		task_dir = level_dir / task
		if not task_dir.exists():
			error(f"{task} is not a valid task, no task directory {task_dir} exists")
		if not (task_dir / ".task.json").exists():
			error(f"Task {task} does not contain .task.json file!")
		with open(task_dir / ".task.json") as f:
			task_data = json.load(f)

		os.system(f"make clean -C {task_dir} > /dev/null")
		r = os.system(f"make compile -C {task_dir} > /dev/null")
		if r != 0:
			error(f"make compile for task '{task}' failed!")
		os.system(f"make clean -C {task_dir} > /dev/null")

		if pathlib.Path(f"{level_dir}/{task}/quartus").exists():
			os.system(f"make qclean -C {task_dir} > /dev/null")

		vhd_files = {}
		for path in task_dir.glob(f"**/*.vhd"):
			with open(path) as f:
				lines = len(list(f.readlines()))
			vhd_files[str(path.relative_to(level_dir))] = lines

		total_expected = 0
		total_actual = 0

		for file in task_data["files"]:
			check_type = task_data["files"][file]["Type"]
			if check_type == "DONT CARE" or check_type == "CONSTANT" or check_type == "COMPLETE":
				if not (task_dir / file).exists():
					error(f"Missing expected file {task_dir / file} -- Please note that you are not allowed to delete the files we provide you with!")
				elif check_type == "COMPLETE":
					actual = task_data["files"][file]["Lines"]
					total_actual += actual
					with open(task_dir / file, "rb") as submitted_file:
						expected = len(submitted_file.readlines())
						total_expected += expected
						if actual - expected == 0:
							error(f"It seems like you did not implement {task_dir / file}. If you think this is an error please contact the teaching staff!")
				elif check_type == "CONSTANT":
					actual = task_data["files"][file]["Hash"]
					expected = hash_file_digest(task_dir / file, 'sha256')
					if expected != actual:
							error(f"You modified {task_dir / file} -- Please note that you must not modify this file - if you believe this to be an error please contact the teaching staff.")
			elif check_type == "CREATE":
				if not (task_dir / file).exists():
					error(f"Missing expected {task_dir / file} -- Please note that you are required to create this file - refer to the task description!")
			else:
					error(f"Unsupported submission check type {check_type}")

		if total_expected - total_actual == 0:
			error(f"You don't have a solution for task '{task}'. If you think this is an error please contact the teaching staff!")
		if abs(total_expected-total_actual) < 5:
			warning(f"You want to submit task '{task}'. However, it seems that you don't have a solution for it! Is this a mistake?")

		for check in task_data["checks"]:
			r = os.system(f"cd {task_dir} && {check['cmd']}")
			if r != 0:
				error(f"task '{task}' - {check['msg']} If you think this is an error please contact the teaching staff!")
		total_points += int(task_data["points"])

	message(f"You submitted {len(tasks)} tasks worth {total_points} points: {' '.join(tasks)}")
	slog.close()
	os.system(f"cd {level_dir} && tar -czf submission_{level}.tar.gz {' '.join(tasks)} submission.log")
	print(f"Created submission archive: submission_{level}.tar.gz")
	print("Please DO NOT forget to upload it to TUWEL!")


def main():
	if len(sys.argv) < 3:
		usage()
		exit(1)

	d = f"tasks/{sys.argv[1]}"
	if not pathlib.Path(d).exists():
		print(f"{d} does not exist!")
		exit(1)

	create_submission_archive(d, sys.argv[2:])

if __name__ == "__main__":
	main()
