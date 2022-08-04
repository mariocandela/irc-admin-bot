#!/usr/bin/perl
#       "Irc Bot by Mario." - copyleft 2009, Mario ( candela.mario@hotmail.it )
#       Sito:  http://www.stylemario.alervista.org
#       Forum: http://openhack.altervista.org
#
# 	   Default irc server: irc.azzurra.it
# 	   Default channel: #openh4ck
#
#      This is a free software; you can redistribute it and/or modify
#      it under the terms of the GNU General Public License as published by
#      the Free Software Foundation; either version 3 of the License.
#     
#      This program is distributed in the hope that it will be useful,
#      but WITHOUT ANY WARRANTY; withou even the implied warranty of
#      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#      GNU General Public License for more details.

use IO::Socket;

## Dati Connessione Irc Bot ##
my $ircserver = 'irc.azzurra.org';
my $ircport = 6668;
my $ircchannel = '#openh4ck';
my $user = 'M4B0T_';
my $password = '******';
my $log='irc_log.txt';
my $risp = "0"; 
## Fine dati Connessione ##

## Prototipi Funzioni By Mario ##
sub ping
{
	my ($n,$sock) = (shift,shift);
    if ($n =~ /PING :(.+)/) 
	{
		print $sock "PONG :$1"; 
	}
}
sub server
{
	my ($n,$sock,) = (shift,shift);
	if ($n =~ /.+00.+/ && !$temp) 
	{
					sleep(2);
        print $sock "PRIVMSG NickServ :IDENTIFY ".$password."\r\n";
					sleep(2);
		print $sock "JOIN ".$ircchannel."\r\n";
		print $sock "PRIVMSG ".$ircchannel." :Ciao a tutti gli utenti di ".$ircchannel."!\r\n";
		$temp = 1;
	}
}
sub forum
{
	my ($sock,$str) = (shift,shift);
	if ($str =~ /!forum/i)
	{ 	
		print $sock "PRIVMSG ".$ircchannel." :http://www.openh4ck.altervista.org/\r\n"; 
	}
}
sub cerca
{
	my ($sock,$stringa) = (shift,shift);
	if($stringa =~ /(!cerca|!search) (.+)$/i)
	{
		print $sock "PRIVMSG ".$ircchannel." :Google: http://www.google.it/search?q=".$2."\n";
		print $sock "PRIVMSG ".$ircchannel." :Wikipedia: http://it.wikipedia.org/wiki/".$2."\n";
		print $sock "PRIVMSG ".$ircchannel." :YouTube: http://www.youtube.com/results?search_query=".$2."\n";
	}
}
sub timebot
{
	($sock,$stringa) = (shift,shift);
	my $ora = `date +%R`;
	if ($stringa =~ /!time/i)
	{ 	
		print $sock "PRIVMSG ".$ircchannel." :Sono le: ".$ora; 
	}
}
sub kick
{
	($sock,$stringa,$nick) = (shift,shift,shift);
	$stringa =~ s/\.//;
	if ($stringa =~ /(madonna|dio|boia|suca|!list|fottiti|stronz[oa]|fottiti|gay|froci[oa]|puttana|cazzo|coglion[ea]|vaffanculo|troia)/i)
	{
		print $sock "KICK ".$ircchannel." ".$nick." Abuso!\r\n";
	}
}
sub antikick
{
	my ($n,$sock) = (shift,shift);
	if ($n =~ /^:.+!~.+ KICK #.+ .+ :.+/){ print $sock "JOIN ".$ircchannel."\r\n"; }
	if ($n =~ /Cannot join channel/i) { print $sock "JOIN ".$ircchannel."\r\n"; }
}
sub joinirc
{
	 my ($n,$sock) = (shift,shift);
	 if ($n =~ /^:(.+)!~.+ JOIN :#.+$/)
	 { 
		 if ($1 !~ /$user/)
		 {
			 print $sock "PRIVMSG ".$ircchannel." :".$1.": Benvenuto in ".$ircchannel."!\r\n";
		 }
	 }
}
sub restartbot
{
	my ($sock,$mode,$canale,$stringa) = (shift,shift,shift,shift);
	if(($mode =~ /PRIVMSG/) && ($canale =~ /$user/) && ($stringa =~ /(!restart|!riavvia) (.+)/))
	{
		if($2 =~ /$password/)
		{
			print $sock "KICK ".$ircchannel." ".$user." Restart!\r\n";
		}
	}
}
sub quitbot
{
	my ($sock,$mode,$canale,$stringa) = (shift,shift,shift,shift);
	if(($mode =~ /PRIVMSG/) && ($canale =~ /$user/) && ($stringa =~ /(!quit|!close) (.+)/))
	{
		if($2 =~ /$password/)
		{
			print $sock " PRIVMSG ".$ircchannel." :Arrivederci a tutti!\r\n";
			print $sock " QUIT :ciao!"."\n";
			exit;
		}
	}
}
sub op
{
		my ($sock,$mode,$canale,$stringa) = (shift,shift,shift,shift);
		if(($mode =~ /PRIVMSG/) && ($canale =~ /$user/) && ($stringa =~ /(!op|!unop) (.+) (.+)/))
		{
			my ($mod,$pass,$nick) = ($1,$2,$3);
			if($mod =~ /!op/)
			{
				if($pass =~ /^$password$/)
				{
					print $sock " MODE ".$ircchannel." +o ".$nick."\r\n";
				}
			}
			if($mod =~ /!unop/)
			{
				if($pass =~ /^$password$/)
				{
					print $sock " MODE ".$ircchannel." -o ".$nick."\r\n";
				}
			}
		}
}
sub logbot
{
	my ($n,$nick,$stringa) = (shift,shift,shift);
	open (FILE, "+>>", $log);
	if ($n =~ /^:(.+)!~.+ JOIN :#.+$/ )	{		print FILE "Join: ".$1."\n";	}
	if ($n =~ /^:.+!~.+ PRIVMSG .+ :.+/i )	{		print FILE $nick.": ".$stringa."\n";	}
	if ($n =~ /^:(.+)!~.+ PART #.+ :.+$/ )	{		print FILE "Quit: ".$1."\n";	}
	close (FILE);
}
sub lol
{
	my ($sock,$str) = (shift,shift);
	@lol = ('lol','xD','asd','haha','hihi','wtf');
	if ($str =~ /^.+ (lol|xd|asd|haha|hihi|wtf)/i)
	{
		print $sock "PRIVMSG ".$ircchannel." :".$lol[int(rand(@lol))]."\r\n"; 
	}
}
sub spam
{
	my ($sock,$str,$nick) = (shift,shift,shift);
	if ($str =~ /http:\/\/.+\/|http:\/\/.+|www..+..+/i)
	{ 	
		print $sock "PRIVMSG ".$ircchannel." :".$nick." In questo canale è vietato lo spam!\r\n"; 
	}
}
sub info
{
	my ($sock,$str) = (shift,shift);
	if ($str =~ /!info|!help/i)
	{ 	
		print $sock "PRIVMSG ".$ircchannel." :M4B0T_: http://stylemario.altervista.org/ircbot/ \r\n";
	}
}
sub saluto
{
	my ($sock,$str,$nick) = (shift,shift,shift);
	@saluto = ('Hola','Ciao','Salve','Hello','Hi','Weila');
	if ($str =~ /hola $user|ciao $user|salve $user|benvenuto $user|giorno $user|hello $user|weila $user/i)
	{
		print $sock "PRIVMSG ".$ircchannel." :".$saluto[int(rand(@lol))]." ".$nick."\r\n";
		$risp = "1"; 
	}	
}
sub difbot
{
	($sock,$stringa,$nick) = (shift,shift,shift);
	if ($stringa =~ /$user/i) 
	{ 
		if($risp != 1){	print $sock "PRIVMSG ".$ircchannel." :".$nick." Non parlare con me, sono soltanto un bot!\r\n"; }
		$risp = "0";
	}
}
## Fine Prototipi Funzioni ##

## Connessione al server irc ##
my $irc = new IO::Socket::INET ( 
	PeerHost => $ircserver, 
	PeerPort => $ircport,
	Proto => 'tcp', 
) or die "Errore: Connessione server irc: ".$ircserver."\n\r";

print $irc "NICK ".$user."\r\n";
print $irc "USER ".$user." 0 *: Perl IRC Bot By Mario\r\n";

### Data-Ora ###
my $data = `date +%D`;
my $ora = `date +%R`;
chop($data);
open (FILE, "+>>", $log);
print FILE "#\n# Data: ".$data." Ora: ".$ora."# \n";
close (FILE);
### Fine Data-Ora ###

## Ciclo connessione irc ##
while (<$irc>)
{
### Regex Risposte Server ###
$_ =~ /^:(.+)!~.+ (.+) (.+) :(.+)/;
my ($nick,$mode,$canale,$str) = ($1,$2,$3,$4);

### Printa sul terminale le risposte del server.
print $_;

forum($irc,$str);
saluto($irc,$str,$nick);
difbot($irc,$str,$nick);
cerca($irc,$str);
timebot($irc,$str);
restartbot($irc,$mode,$canale,$str);
quitbot($irc,$mode,$canale,$str);
op($irc,$mode,$canale,$str);
kick($irc,$str,$nick);
logbot($_,$nick,$str);
lol($irc,$str);
spam($irc,$str,$nick);
info($irc,$str);
antikick($_,$irc);
joinirc($_,$irc);
ping ($_,$irc);
server ($_,$irc);
}
close ($irc);
