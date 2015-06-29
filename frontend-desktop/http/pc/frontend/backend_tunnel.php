<?php
/**
 * @file
 * Tunnel vom Frontend-Server zum Backend für den Frontend-Client.
 * Der Tunnel wird von den Frontend-Fassaden verwendet.
 */

define("ENTRYPOINT", "http://localhost/backend/service");

function relay($data, $path) {
  $post_array = array();
  foreach($data as $key => $value) {
    $post_array[$key] = $value;
  }

  $ch = curl_init();
  curl_setopt_array($ch, array(
    CURLOPT_URL => ENTRYPOINT . "/" . $path,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $post_array,
    CURLOPT_HEADER => true,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_USERAGENT => $_SERVER['HTTP_USER_AGENT']));

  // Relay answer
  list($foo, $header, $contents) = preg_split('/([\r\n][\r\n])\\1/', curl_exec($ch), 3);

  // Split header text into an array.
  $header_text = preg_split('/[\r\n]+/', $header);
  foreach ($header_text as $header ) {
    header('Content-Type: text/html');
  }

  print $contents;
  curl_close($ch);
}

function returnRelay($data,$path) {
  $post_array = array();

  foreach($data as $key => $value) {
    $post_array[$key] = $value;
  }

  $ch = curl_init();

  curl_setopt_array($ch, array(
    CURLOPT_URL => ENTRYPOINT . "/" . $path,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $post_array,
    CURLOPT_HEADER => false,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_USERAGENT => $_SERVER['HTTP_USER_AGENT'])
  );

  // Relay answer
  $contents = curl_exec($ch);
  curl_close($ch);

  return array(
    "content" => $contents,
    //		"url" => ENTRYPOINT . "/" . $path
  );
}

function http_post($url,$data,$header = "") {
  return array(
    'content' => file_get_contents(
      $url, false, stream_context_create(
        array(
          'http' => array(
            'method'  => 'POST',
            'header'  => $header, "Connection: close\r\nContent-Length: ".strlen($data)."\r\n",
            'content' => $data
          )
        )
      )
    ),
    'headers' => $http_response_header
  );
}
