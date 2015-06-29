<?php
	function http_post ($url, $data, $header = "") {
		return array (
			'content' => file_get_contents (
				$url, false, stream_context_create (
					array (
						'http' => array (
							'method'  => 'POST',
							'header'  => $header."Connection: close\r\nContent-Length: ".strlen($data)."\r\n",
							'content' => $data
						)
					)
				)
			), 
			'headers' => $http_response_header
		);
	}
	
	function updateLucene($cols,$csvData) {
		$response = http_post (
				UPDATE_URL."/csv?commit=false",
				implode(",",$cols).$csvData,
				"Content-Type: text/csv\r\n"
		);
		sleep(SLEEP_TIME);
	}
	
	function prepareCol($row) {
		if(!is_numeric($row) OR strstr($row,",") !== false) {
			$row = '"'.str_replace('"','\"',$row).'"';
		}
		
		return $row;
	}
	
	function trunc($word) {
		return "*".$word."*";
	}
?>
