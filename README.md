<h1> minishell_unit_test </h1>

Unit test for the mandatory part of minishell (42cursus project)

</br>

<p float="left">
  <img src="https://github.com/martingarcialopez/minishell_unit_test/blob/main/.images/test_output.png" width="61%" />
  <img src="https://github.com/martingarcialopez/minishell_unit_test/blob/main/.images/diff_output.png" width="30%" />
</p>

<h2> Prerequisites </h2>

Your executable must support the `-c` option, which allows you to pass commands as a string (man bash)

<img  src="https://github.com/martingarcialopez/minishell_unit_test/blob/main/.images/c.png" width="50%"/>

<h2> Installation </h2>

+ Clone this repository at the root of your minishell project

<h2> Usage </h2>

`./unit_test.sh` inside this repository

+ <h3> Options </h3>

  `--no-error` or `-n` Does not test the stderr output, which is tested by default

  </br>
  
  You can run tests of a given section by doing:

  `--<test_section_name>` e.g. `--builtins` Only errors in these tests will be written in the log file. Note that you can combine them

  > ./unit_test.sh --n --builtins --quotes

  will only run the builtins and quotes tests and won't test the stderr output

  </br>
  
  `--help` or `-h` Shows the script usage, mainly the names of each test section and its abreviation
  
  
<h2> Behaviour </h2>

+ For each test, stdout and stderr of your minishell and real bash will be compared, along with their return codes.
For a test to be passed, you need to have the same return code of bash, as well as the same output in the stdout.

+ If the stderr differs, you will see [FAIL] on the stderr column, but that won't affect the previous result of the test. If the stderr is empty or if it doesn't differs, stderr column will be empty.
