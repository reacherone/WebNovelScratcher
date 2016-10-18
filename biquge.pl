#Perl Script for biquge.la
use LWP::Simple qw(getstore);
use Encode;

#Global Parameters:
$bookid=61;

#Grab Table of Content Page
getstore( "http://www.biquge.la/book/$bookid", "toc.html" );
print "Table of Content Download Completed\n";

#Create .ncx Table File
open (tocsource, "<", "toc.html") || die ("Could not open content file");
open (toctarget, ">", "toc.ncx") || die ("Could not create content file");
print toctarget ("  \<docTitle\>
    \<text\>title of book\<\/text\>
  \<\/docTitle\>
  \<navMap\>");

#Read Chapter num & name from Content
$j=0;
while (<tocsource>){
	if(/\<dd\>\<a href\=\"(.*)\.html\"\>(.*?)\<\/a\>\<\/dd\>\<dd\>\<a href\=\"(.*)\.html\"\>(.*?)\<\/a\>\<\/dd\>\<dd\>\<a href\=\"(.*)\.html\"\>(.*?)\<\/a\>\<\/dd\>/){
		@num = (@num, $1, $3, $5);
		@name = (@name, $2, $4, $6);
		$j = $j + 3;}
	elsif(/\<dd\>\<a href\=\"(.*)\.html\"\>(.*?)\<\/a\>\<\/dd\>\<dd\>\<a href\=\"(.*)\.html\"\>(.*?)\<\/a\>\<\/dd\>/){
			@num = (@num, $1, $3);
			@name = (@name, $2, $4);
			$j = $j + 2;}
	elsif(/\<dd\>\<a href\=\"(.*)\.html\"\>(.*?)\<\/a\>\<\/dd\>/){
			@num = (@num, $1);
			@name = (@name, $2);
			$j = $j + 1;}
	}
	
print ("$j\n");
close(tocsource);

#Processing Content
$i++;
$num = shift @num;
$name = shift @name;
print $name;
while(@num){
	if($i>0){
		getstore( "http:\/\/www\.biquge\.la\/book\/$bookid\/$num.html", "$i.html" );
		print "$i\n";
		open (htmlsource, "<", "$i.html") || redo;
		open (htmlresult, ">$i.xhtml");
		while (<htmlsource>){
			if(/\<div id\=\"content\"\>(.*)\<\/div\>/){
				$temp = encode("utf-8",decode("gbk",$1));
				$temp =~ s/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\;//g;
				$temp =~ s/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/
  \<p\>\&nbsp\; \&nbsp\; /g;
				$temp =~ s/\<br.*?\>\<br.*?\>/\<\/p\>\n/g;
				$temp =~ s/rì/日/g;
				$temp =~ s/chūn/春/g;
				$temp =~ s/sè/色/g;
				$temp =~ s/xìng/性/g;
				$temp =~ s/dú lì/独立/g;
				$temp =~ s/shè/射/g;
				$temp =~ s/yīn/阴/g;
				$temp =~ s/zhōng yāng/中央/g;
				$temp =~ s/cāo/操/g;
				$temp =~ s/sāo/骚/g;
				print htmlresult ("<\?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"\?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"
  \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">

<html xmlns=\"http://www.w3.org/1999/xhtml\">
<head>
  <title></title>
</head>

<body>");
				print htmlresult $temp;
				print htmlresult ("\<\/body\>
\<\/html\>");}
		}
		close (htmlsource);
		close (htmlresult);
	}
	print toctarget ("
\<navPoint id\=\"navPoint\-$i\" playOrder\=\"$i\"\>
  \<navLabel\>
    \<text\>$name\<\/text\>
  \<\/navLabel\>
  \<content src\=\"Text\/$i.xhtml\"\/\>
\<\/navPoint\>");
	$i++;
	$num = shift @num;
	$name = shift @name;
	print $name;
	next;
}
#Final Chapter
getstore( "http:\/\/www\.biquge\.la\/book\/$bookid\/$num.html", "$i.html" );
print "$i\n";
open (htmlsource, "<", "$i.html") || die ("Could not open file");
open (htmlresult, ">$i.xhtml");
while (<htmlsource>){
	if(/\<div id\=\"content\"\>(.*)\<\/div\>/){
		$temp = encode("utf-8",decode("gbk",$1));
		$temp =~ s/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\;//g;
		$temp =~ s/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/
  \<p\>\&nbsp\; \&nbsp\; /g;
		$temp =~ s/\<br.*?\>\<br.*?\>/\<\/p\>\n/g;
		$temp =~ s/rì/日/g;
		$temp =~ s/chūn/春/g;
		$temp =~ s/sè/色/g;
		$temp =~ s/xìng/性/g;
		$temp =~ s/dú lì/独立/g;
		$temp =~ s/shè/射/g;
		$temp =~ s/yīn/阴/g;
		$temp =~ s/zhōng yāng/中央/g;
		$temp =~ s/cāo/操/g;
		$temp =~ s/sāo/骚/g;
		print htmlresult ("<\?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"\?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"
  \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">

<html xmlns=\"http://www.w3.org/1999/xhtml\">
<head>
  <title></title>
</head>

<body>");
		print htmlresult $temp;
		print htmlresult ("\<\/body\>
\<\/html\>");}
}
close (htmlsource);
close (htmlresult);
print toctarget ("
\<navPoint id\=\"navPoint\-$i\" playOrder\=\"$i\"\>
  \<navLabel\>
    \<text\>$name\<\/text\>
  \<\/navLabel\>
  \<content src\=\"Text\/$i.xhtml\"\/\>
\<\/navPoint\>");
#End of Table
print toctarget ("
	\<\/navMap\>
\<\/ncx\>");
close (toctarget);