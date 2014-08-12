$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

$textfile = "$here\text.txt"

function Before {
	Param([int] $n)
	$ok = $false
	Remove-Item $textfile
	New-Item $textfile -ItemType file > $null
	for ($i = 1; $i -le $n; $i++) {
		$line = $i.ToString() + "行目"
		Add-Content -Path $textfile -Value $line -Encoding utf8
	}			
}

Describe "spl010" {

  It "3行出力" {
  	Before 3
		spl010 $textfile | Should Be "1 : 1行目\n2 : 2行目\n3 : 3行目\n"
  }

  It "2行出力" {
  	Before 2
		spl010 $textfile | Should Be "1 : 1行目\n2 : 2行目\n"
  }

  It "1行出力" {
  	Before 1
		spl010 $textfile | Should Be "1 : 1行目\n"
  }

  It "0行出力" {
  	Before 0
		spl010 $textfile | Should Be ""
  }

	It "ファイルが存在しない場合、ナル値が戻る" {
		$textfile = "c:\notexist"
		Remove-Item $textfile 2>$null
		spl010 $textfile | Should Be $null
	}
}
