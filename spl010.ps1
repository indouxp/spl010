#
# utf-8のテキストファイルを読み込み、一行ごとに処理する
#
function spl010 {
  Param([string]$inFile)	# 入力ファイル
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
