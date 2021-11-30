#!/usr/bin/env lua
-- compile and run a program with cc

local executeex = require("pl.utils").executeex
local format = require("string").format
local path = require("pl.path")

local function parse_args()
	-- parse arguments
	local lapp = require("pl.lapp")
	local args = lapp([[
  Compile and run a program
    -q, --quiet      Suppress all unnecessary output.
    --recompile      Recompile the source file, even if a newer, compiled version exists.
    -t, --tmp        Compile the program to a temporary directory.
    <file> (string)  The file to compile and run.
  ]])
	return args
end

local function die(msg)
	local os = require("os")
	local stderr = require("io").stderr
	-- print an err to stderr and exit with failure
	stderr:write(format("[ERR] %s\n", msg))
	os.exit(1)
end

local function run(command, quiet)
	-- run the compiled file
	if not quiet then
		print(format("Running '%s'...", command))
	end
	local success, exit_code, stdout, stderr = executeex(command, true)
	if not success then
		print(format("'%s' exited with code %d.\nstdout:\t%s\nstderr:\t%s\n", command, exit_code, stdout, stderr))
	end
	return success, stdout
end

local function compile(file, outfile, quiet, compiler_flags)
	-- compile a program
	if not compiler_flags then
		compiler_flags = format("-Wall -Werror -O2 -std=c99 -pedantic -o %s %s", outfile, file)
	end
	local command = format("cc %s", compiler_flags)
	return run(command, quiet)
end

local function is_outfile_newer(source_file, outfile)
	-- check if a compiled file is newer than it's source file. if so, return true
	local file = require("pl.file")
	if path.exists(outfile) and file.modified_time(outfile) > file.modified_time(source_file) then
		return true
	else
		return false
	end
end

local function main()
	-- main operations
	local stringx = require("pl.stringx")
	local args = parse_args()
	local file = args.file

	if not path.exists(file) then
		die(format("File '%s' does not exist.\n", file))
	end

	-- set and create the compilation directory
	local compile_dir
	if not args.tmp then
		compile_dir = "./build"
	else
		compile_dir = "/tmp/cr"
	end
	if not path.exists(compile_dir) then
		path.mkdir(compile_dir)
	end

	local outfile = format("%s/%s", compile_dir, stringx.split(file, ".")[1])
	if not is_outfile_newer(file, outfile) and not args.recompile then
		local success = compile(file, outfile, args.quiet)
		if not success then
			die("Compilation failed. Exiting.")
		end
	else
		print("Found an up-to-date outfile; skipping compilation...")
	end

	local success, stdout = run(outfile, args.quiet)
	if not success then
		die(format("Failed to run '%s'."), file)
	end
	io.write(stdout)
end

main()
