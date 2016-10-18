#Version 1.0 for oklink.net
use LWP::Simple qw(getstore);
use Encode;

getstore( "http://www.oklink.net/wxsj/jing-yong/lean-on-sky/index.html", "toc.html" );
print "Content Download Completed\n";
open (source, "<", "toc.html") || die ("Could not open content file");
open (content, ">", "toc.ncx") || die ("Could not write content file");
print content ("  \<docTitle\>
    \<text\>title of book\<\/text\>
  \<\/docTitle\>");
while (<source>){
	#if(/HREF=\"\d(\d\d).htm\"\>[\x80-\xFF]{2}\d\d[\x80-\xFF]{2}[\x80-\xFF]{2}(.*?)\<\/a\> \<\/td\>/){
	if(/HREF=\"0(\d\d).htm\"\>(.*?)\<\/a\> \<\/td\>/){
		@array = (@array, $1,$2);}
	}
	while(@array){
		$i++;
		$num = shift @array;
		$name = shift @array;
		print "$name\n";
		if($i>0){
		getstore( "http:\/\/www\.oklink\.net\/wxsj\/jing\-yong\/lean\-on\-sky\/0$num.htm", "$i.htm" );
		open (htmlsource, "<", "$i.htm") || die ("Could not open source file");
		open (htmlresult, ">$i.xhtml") || die ("Could not write result file");
		$para = 0;
		print htmlresult ("<\?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"\?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"
  \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">

<html xmlns=\"http://www.w3.org/1999/xhtml\">
<head>
  <title></title>
</head>

<body>");
		while (<htmlsource>){
			if(/\<td\>\<pre\>\<span class\=\"content\"\>/){
				$content = 1;}
			if(/\<\/center\>\<\/div\>/){
				$content = 0;
				print htmlresult "\<\/p\>\n"}
			if($content){
				if($para){
					if(/    ([\x80-\xFF]{2}.*[\x80-\xFF]{2})/){
						$temp = encode("utf-8",decode("gbk",$1));
						print htmlresult "\<\/p\>\n
  \<p\>\&nbsp\; \&nbsp\; $temp";}
					if(/([\x80-\xFF]{2}.*[\x80-\xFF]{2})/){
						$temp = encode("utf-8",decode("gbk",$1));
						print htmlresult $temp;}
						next;
					next;}
				elsif(/    ([\x80-\xFF]{2}.*[\x80-\xFF]{2})/){
					$temp = encode("utf-8",decode("gbk",$1));
					print htmlresult "
  \<p\>\&nbsp\; \&nbsp\; $temp";
					$para = 1;
					next;}}
			next;}
		print htmlresult ("\<\/body\>
\<\/html\>");
		close (htmlsource);
		close (htmlresult);}
		$num =~ s/\b0+//g;
		print content ("\<navMap\>
    \<navPoint id\=\"navPoint\-$num\" playOrder\=\"$num\"\>
      \<navLabel\>
        \<text\>$name\<\/text\>
      \<\/navLabel\>
      \<content src\=Text\/\"$i.xhtml\"\/\>
    \<\/navPoint\>");
	next;}
	print content ("
	\<\/navMap\>
\<\/ncx\>");
	close (content);
