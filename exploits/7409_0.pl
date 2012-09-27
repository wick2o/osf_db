use URI::Escape;
require HTTP::Request;
use LWP::UserAgent;


# Define the page we want to see the HTML source
$html_page = "http://www.protecthtml.com/product/wp/sample21.htm";

$ua = LWP::UserAgent->new;
$request = HTTP::Request->new(GET => $html_page );
$response = $ua->request($request);
if ($response->is_success) {
         $encrypted_html =$response->content;
} else {
        print $response->error_as_HTML;
        exit(0);
}

# Some try to overwrite document.write by doing something like
#       document.write = null;
# so we're going to search the source code for any document.write=
# or its escaped version which is:
#       %64%6F%63%75%6D%65%6E%74%2E%77%72%69%74%65%3D
$encrypted_html =~ s/document.write[ ]*=(.*)\;/void_var=$1/i;

# -- this is all on the same line --
$encrypted_html =~
s/%64%6F%63%75%6D%65%6E%74%2E%77%72%69%74%65(%20)*(%3D)(.*)
\;/void_var=$3/i;

# All scripts have to use a document.write to write the decrypted HTML
# to the browser window so all we're going to do is add a <PLAINTEXT>
# tag to make sure that the derypted html is not decoded by the browser
# and instead we see the source code!
# -- this is all on the same line --
$encrypted_html =~ s/document.write[
]*\((.*?)
\)/document.write\(\\\"<PLAINTEXT>\\\"+$1+\\\"<\/PLAINTEXT>\\\"\)/gi;

# -- this is all on the same line --
$encrypted_html =~
s/%64%6F%63%75%6D%65%6E%74%2E%77%72%69%74%65(%20)*%28(.*?)%
29/document.write\(\\\"<PLAINTEXT>\\\"+$2+\\\"<\/PLAINTEXT>\\\"\)/gi;

open(OUT,">clear_text.html");
print OUT $encrypted_html;

# Some LAME tools don't even try to encrypt the pages they just URL encode
everything
print OUT "<p> Let us try just to Unescape the source! <PLAINTEXT>";
print OUT uri_unescape($response->content);
close(OUT);


