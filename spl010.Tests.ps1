$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

$textfile = "$here\text.txt"

function Before {
	Param([int] $n)
	MakeTextFile $n	
}
function After {
	RemoveTextFile
}

function RemoveTextFile {
	Remove-Item $textfile -force
}

#
# 読み込み付加のファイルを作成
#
function DenyRead {
	Param([string] $file)
	$hostname = hostname
	$user = "$hostname\indou"
	$aclparam = @($user, "Read", "Deny")
	$rule = New-Object System.Security.AccessControl.FileSystemAccessRule  $aclparam
	$acl = get-acl $file
	$acl.AddAccessRule($rule)
	set-acl $file -AclObject $acl
}

#
# utf8のテキストファイルを指定行数分作成する
#
function MakeTextFile {
	Param([int] $n)
	$ok = $false
	Remove-Item $textfile 2> $null
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
		After
  }

  It "2行出力" {
  	Before 2
		spl010 $textfile | Should Be "1 : 1行目\n2 : 2行目\n"
		After
  }

  It "1行出力" {
  	Before 1
		spl010 $textfile | Should Be "1 : 1行目\n"
		After
  }

  It "0行出力" {
  	Before 0
		spl010 $textfile | Should Be ""
		After
  }

	It "ファイルが存在しない場合、ナル値が戻る" {
		$textfile = "c:\notexist"
		Remove-Item $textfile 2>$null
		spl010 $textfile | Should Be $null
	}

	It "ファイルに読み込み権限がない場合、ナル値が戻る" {
		Remove-Item $textfile 2>$null
		Before 3
		DenyRead $textfile
		spl010 $textfile | Should Be $null
		After
	}
}
