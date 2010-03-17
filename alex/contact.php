<?php

top();

$me = $_SERVER['PHP_SELF']; 

if($_POST['submit']!='Submit'){
	echo ("
		<form name='contactform' method='post' action='$me'>
		 	<table width='450px'>
				</tr>
				<tr>
				 <td valign='top'>
				  <label for='first_name'>First Name *</label>
				 </td>
				 <td valign='top'>
				  <input  type='text' name='first_name' maxlength='50' size='30'>
				 </td>
				</tr>
				<tr>	
				 <td valign='top'>
				  <label for='last_name'>Last Name *</label>
				 </td>
				 <td valign='top'>
				  <input  type='text' name='last_name' maxlength='50' size='30'>
				 </td>
				</tr>
				<tr>	
				 <td valign='top'>
				  <label for='email'>Email Address *</label>
				 </td>
				 <td valign='top'>
				  <input  type='text' name='email' maxlength='80' size='30'>
				 </td>
				</tr>
				<tr>
				 <td valign='top'>
				  <label for='telephone'>Telephone Number</label>
				 </td>	
		 		 <td valign='top'>
				  <input  type='text' name='telephone' maxlength='30' size='30'>
				 </td>	
				</tr>
				<tr>
				 <td valign='top'>
				  <label for='comments'>Comments *</label>
				 </td>
				 <td valign='top'>
				  <textarea  name='comments' maxlength='1000' cols='25' rows='6'></textarea>
				 </td>	
				</tr>
				<tr>
				 <td colspan='2' style='text-align:center'>
				  <input type='submit' value='Submit' name='submit'>  <!--<a href='http://www.freecontactform.com/email_form.php'>Email Form</a>-->
				 </td>
				</tr>
			</table>
		</form>
	");
}else{
	// EDIT THE 2 LINES BELOW AS REQUIRED
	$email_to = "you@yourdomain.com";
	$email_subject = "Your email subject line";

	// Some laziness. I don't like long variable names. Also provides an easy 
	// way to see just how much of their code I plagiarised:
	$first_name = $_POST['first_name'];
	$last_name = $_POST['last_name'];
	$email = $_POST['email'];
	$telephone = $_POST['telephone'];
	$comments = $_POST['comments'];

	// This chunk is checking that each submission is non-zero. This is (currently) 
	// all the validation we bother to do.
	// If any are non-zero, it re-presents the form for filling in again. 
	// This gets called again on next form submission, so with a really stupid user
	// the process can go on forever. This is considered a feature.

	// Everything that is indented as far as the line below the one below this 
	// chunk (beginning 'empty ($_POST['last_name']' ) up to the next thing that 
	// lines up with here (i.e. one tab in, or in line with if(empty)) is executed 
	// when the form is submitted incorrectly filled in. 

	if(empty($_POST['first_name']) ||
		empty($_POST['last_name']) ||
		empty($_POST['email']) ||
//		empty($_POST['telephone']) ||
		empty($_POST['comments'])) { 

		echo ("	

			<h2>Oop. There appears to have been a problem. Please check you've filled out everything marked with an asterisk (*) below.</h2>

			<form name='contactform' method='post' action='$me'>
			 	<table width='450px'>
					</tr>
					<tr>
					 <td valign='top'>
		");
		if (empty($first_name)){
			echo ("	
					<label for='first_name'><strong>First Name *</strong></label>
			");
		}else{
			echo ("
					<label for='first_name'>First Name *</label>
			");
		}
		echo("
					 </td>
					 <td valign='top'>
					  <input  type='text' name='first_name' maxlength='50' size='30' value='$first_name'>
					 </td>
					</tr>
					<tr>	
					 <td valign='top'>
		");
		if (empty($last_name)){
			echo("
					<label for='last_name'><strong>Last Name *</strong></label>
			");
		}else{
			echo("
					  <label for='last_name'>Last Name *</label>
			");
		}
		echo ("
					 </td>
					 <td valign='top'>
					  <input  type='text' name='last_name' maxlength='50' size='30' value='$last_name'>
					 </td>
					</tr>
					<tr>	
					 <td valign='top'>
		");
		if (empty($email)){
			echo("
					  <label for='email'><strong>Email Address *</strong></label>
			");
		}else{
			echo("
					  <label for='email'>Email Address *</label>
			");
		}
		echo("
					 </td>
					 <td valign='top'>
					  <input  type='text' name='email' maxlength='80' size='30' value='$email'>
					 </td>
					</tr>
					<tr>
					 <td valign='top'>
					  <label for='telephone'>Telephone Number</label>
					 </td>	
			 		 <td valign='top'>
					  <input  type='text' name='telephone' maxlength='30' size='30'>
					 </td>	
					</tr>
					<tr>
					 <td valign='top'>
		");
		if (empty($comments)){
			echo ("
					  <label for='comments'><strong>Comments *</strong></label>
			");
		}else{			  
			echo("
					  <label for='comments'>Comments *</label>
			");
		}
		echo("
					 </td>
					 <td valign='top'>
					  <textarea  name='comments' maxlength='1000' cols='25' rows='6'>$comments</textarea>
					 </td>	
					</tr>
					<tr>
					 <td colspan='2' style='text-align:center'>
					  <input type='submit' value='Submit' name='submit'>  <!--<a href='http://www.freecontactform.com/email_form.php'>Email Form</a>-->
					 </td>
					</tr>
				</table>
			</form>
		
		");	
	
				
	}else{
	// This bunch of code is only executed if the form is filled in satisfactorally
	// it's worth bearing in mind that 'satisfactorally' means 'has some data in it'.

	
		// create email headers
		$headers = 'From: '.$email_from."\r\n".
		'Reply-To: '.$email_from."\r\n" .
		'X-Mailer: PHP/' . phpversion();
		// @mail($email_to, $email_subject, $comments, $headers);  
		echo" (@mail($email_to,$email_subject, $comments, $headers) ";

		echo ("
	
		<!-- include your own success html here -->



		");
	}
}

bottom();

function top() {
	echo ("
	CTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0 Transitional//EN'>
	<HTML><HEAD><TITLE>Racer's Guild of Cannock Chase - Homepage</TITLE>
	<META http-equiv=Content-Type content='text/html; charset=unicode'><!--  Created with NOTEPAD!  -->
	<META content='MSHTML 6.00.6000.16945' name=GENERATOR>
	<META 
	content='Homepage for downhill mountain biking at Cannock Chase, including trail building and Freelap practice days.' 
	name=description>
	<META content='downhill, mountain biking, cannock chase, stile cop, freelap' 
	name=keywords>
	<STYLE type=text/css>
	  <!--
	    /* Don't underline links */
	    a:link {text-decoration: none;}
	    a:visited {text-decoration: none;}
	    /* Custom Scrollbar Colors */
	    body{
	      scrollbar-arrow-color: #333333;
	      scrollbar-3dlight-color: #e6d6a5;
	      scrollbar-highlight-color: #333333;
	      scrollbar-face-color: #e6d6a5;
	      scrollbar-shadow-color: #333333;
	      scrollbar-darkshadow-color: #e6d6a5;
	      scrollbar-track-color: #e6d6a5;
	    }
	  -->
	  </STYLE>
	</HEAD>
	<BODY text=#333333 vLink=#800080 aLink=#ff0000 link=#0000ff bgColor=#000000>
	<DIV>
	<TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=799 align=center 
	bgColor=#000000 border=0>
	  <TBODY>
	  <TR vAlign=top>
	
	    <TD width=799 colSpan=5 height=150><MAP name=banner><AREA shape=RECT 
	        alt=Home coords=40,30,80,50 href='home.html'><AREA shape=RECT 
	        alt='What's this all about and how do I join?' coords=440,30,485,50 
	        href='about.html'><AREA shape=RECT alt='2010 Race Calendar' 
	        coords=490,30,550,50 href='2010_calendar.html'><AREA shape=RECT 
	        alt='Description of downhill trails' coords=555,30,600,50 
	        href='trails.html'><AREA shape=RECT alt='Timed results and stats' 
	        coords=605,30,650,50 href='results.html'><AREA shape=RECT 
	        alt='Member profiles' coords=665,30,725,50 href='members.html'><AREA 
	        shape=RECT alt='To Bikeadventures downhill forum' coords=730,30,775,50 
	        href='http://www.bikeadventuresuk.com/forum/viewforum.php?f=12'></MAP><IMG 
	      style='Z-INDEX: 100; POSITION: absolute' height=150 alt='' 
	      src='Images/RG Parchment 799x150 2.gif' width=799 align=top useMap=#banner 
	      border=0> </TD></TR>
	  <TR vAlign=top>
	    <TD width=60 height=1000><IMG style='Z-INDEX: 100; POSITION: absolute' 
	      height=1000 alt='' src='Images/L_Border.jpg' width=60 align=top border=0> 
	    </TD>
	    <TD align=middle width=680 bgColor=#e6d6a5 height=818><FONT 
	      size=2><BR>Joining the guild is free - all you need to do is to have attended at 
	      least one of our timed practices.<BR>Why become a member?<BR>
	Recieve regular newsletters from Racersguild<br>
	Get free or discounted membership to British Cycling<BR>Get preferential rates from our friends at 
	      Descent-Gear.com (see details below).<BR>And of course you're a part of a 
	      1very cool collective of Midlands riders!</FONT><BR><FONT size=2><BR>Have questions about joining? Contact: </FONT><A 
	      href='mailto:join@racersguild.co.uk'><FONT 
	      size=2>Join@racersguild.co.uk</FONT></A>
	
	<br><strong>2008-2009 members should also complete the form to ensure they are kept up to date!</strong><br>
	<FONT size=2> </FONT><BR><BR><FONT 
	      style='BACKGROUND-COLOR: #e6d6a5'><IMG height=37 alt='' 
	      src='Images/Guild Members Banner.jpg' width=315 align=center 
	      border=0><BR></FONT><FONT style='BACKGROUND-COLOR: #e6d6a5'></FONT><FONT 
	      size=1>Please fill in the form below to join RG<BR>
	");
}
function bottom() {
	echo("

<FONT style='BACKGROUND-COLOR: #e6d6a5'></FONT><FONT 
      size=1>Your information is safe with us. We promise not to sell it,<BR>
misuse or abuse it, we will NEVER send you spam<br>

<br><br><br>




      <DIV align=center><A href='http://www.descent-gear.com'><IMG 
      style='Z-INDEX: 100; POSITION: relative' height=46 
      alt='Click to go to Descent-Gear!' src='Images/Descent_Gear_Banner.jpg' 
      width=210 border=0></A>&nbsp;<BR><BR><FONT size=2>CALL SI @ 07968 229 359, 
      MENTION THE GUILD, AND HE WILL BEAT ANY PRICE.<BR><BR>Our friends at 
      Descent-Gear are supporting&nbsp;Racer's Guild in 2010 by covering the 
      rather large cost of number plates.<BR>Not only that, but Si will make 
      sure RG members get the best deals on DH kit if they shop at Descent 
      Gear.&nbsp;&nbsp;<BR>That means prices below CRC!&nbsp; <BR>Click the 
      above link to browse the shop&nbsp;and then&nbsp;PHONE IN YOUR ORDER and 
      speak with Si Paton.</FONT></DIV><IMG 
      style='Z-INDEX: 100; LEFT: 0px; POSITION: relative; TOP: 20px' height=56 
      alt='' src='Images\bclogo.jpg' width=150 border=0> <BR><BR><FONT 
      size=2><BR>DETAILS ABOUT FREE BRITISH CYCLING MEMBERSHIP<BR><BR>The 
      Racer's Guild of Cannock Chase is&nbsp;affiliated with British 
      Cycling.&nbsp;&nbsp;Those who want to join BC<BR>can get a free Bronze 
      membership by claiming membership to the Racer's Guild. <BR><BR>HOW TO 
      JOIN:&nbsp; Click <A 
      href='https://www.britishcycling.org.uk/web/site/BC/bcf/bcApplicationFormTmp.asp?promo=club2'><U>here</U></A> 
      to go to the membership form on BC's website.&nbsp; Fill in your 
      details.&nbsp;<BR>Pick 'Racer's Guild of Cannock Chase' from the club 
      finder&nbsp;(search 'Cannock Chase'). <BR><BR>NOTE: If you are joining BC 
      to get a Racing License in order to race National Point Series (NPS) 
      races, <BR>then you must pay for Silver Membership (£22) and separate 
      racing license (£31).<BR><BR>QUESTIONS?&nbsp; The differences between 
      Gold, Silver and Bronze membership can be found<A 
      href='http://www.britishcycling.org.uk/web/site/BC/mem/fb/membership_benefits.asp'> 
      <U>here</U> </A>.<BR>And <A 
      href='http://www.britishcycling.org.uk/web/site/BC/mem/membership_frequently_asked_questions.asp'>here</A> 
      is a handy FAQ for joining&nbsp;BC.</FONT><BR><BR><BR></FONT></TD>

    <DIV></DIV>
    <TD width=59 height=1000><IMG style='Z-INDEX: 100; POSITION: absolute' 
      height=1000 alt='' src='Images/R_Border.jpg' width=59 align=top border=0> 
    </TD></TR></TBODY></TABLE></DIV></MAP></BODY></HTML>

");
}

?>

