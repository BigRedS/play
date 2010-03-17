<?php

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
?>

