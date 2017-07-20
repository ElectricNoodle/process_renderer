#!/usr/local/bin/perl -w


##
## Mental things
##
use strict;
use IPC::Open2;
use IO::Select;
use Cwd 'abs_path';
use POSIX ":sys_wait_h";
use Getopt::Long qw( :config pass_through );


my $s;
my @art;
my @pids;
my $path;
my $process;
my @children_in;
my @children_out;
my $num_processes =6;
my($master,$slave_id, $render_text);

#$SIG{INT}  = \&signal_handler;
#$SIG{TERM} = \&signal_handler;

GetOptions(
	"master"	  => \$master,		
    "slave=i"     => \$slave_id,
    "render=s"	  => \$render_text,
);






push @art,'   ~~    ~~'; 
push @art,'*  ||----||';
push @art,' / |     ||';
push @art,'  /-------\/';
push @art,"         (oo)";
push @art,"         (__)";

if($master){
	
	$path = abs_path($0);
	print "Spawning children...\n";
	master();

}elsif($slave_id){
	slave();
}

sub master {
	my $count = 0;
	while($count <= $num_processes){
		my($chld_out, $chld_in);
   
		my $pid = open2($chld_out, $chld_in, "/usr/bin/perl $path --slave $count");
		
		#print <$chld_out>;
		
		push(@children_in, $chld_in);
		push(@pids, $pid);
		$count++;
	}
	for my $pid (@pids){
		#print "1\n";
		waitpid( $pid, 0 );
	} 	
		while(1){
			for my $child (@children_in){
				print $child "TEST TEST ".int(rand(100))."\n";
			}		

		}

	print "Children spawned($num_processes).\n";
}

sub slave {
	$s = IO::Select->new();
	$s->add(\*STDIN);
	while(1){
		my $foo;
		if ($s->can_read(.5)) {
			#chomp($foo = <STDIN>);
		    #setPSMessage($foo);

		}else{
			#setPSMessage(":(");
		}
		sleep((($slave_id -($slave_id*2) ) *-1));
		setPSMessage($art[$slave_id-1]);
	}
	
}

# Set's the text specified in place of the process name.
sub setPSMessage {
    my ($msg) = @_;
  	$0 = $slave_id.$msg;
}

sub signal_handler {
	if($master){
		exit;
	}
}