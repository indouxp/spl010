function spl010 {
  Param([string]$inFile)
	$i=1
	$enc = [Text.Encoding]::GetEncoding("utf-8")
	try {
		$fh = New-Object System.IO.StreamReader($inFile, $enc)
		$result = ""
		while (($l = $fh.ReadLine()) -ne $null) {
			$result += "$i : $l\n"
			$i++
		}
		$fh.close()
	} catch [Exception] {
		$null
	}
	$result
}
