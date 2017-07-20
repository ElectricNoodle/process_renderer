# process_renderer
A program which renders ascii art into ps/top. Will hopefully include animation at some point too.

Works by creating X Number of child processes, then sending data down them through pipes. 

Makes use of $0 in perl to set process text.
