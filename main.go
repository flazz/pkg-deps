package main

import (
	"fmt"
	"go/parser"
	"go/token"
	"os"
	"strings"
)

func main() {
	set := make(map[string][]string)

	p := os.Args[1]
	if len(os.Args) == 1 {
		fmt.Print("usage: " + os.Args[0] + " PKG")
		os.Exit(1)
	}

	fset := token.NewFileSet()
	pkgs, err := parser.ParseDir(fset, p, nil, parser.ImportsOnly)
	if err != nil {
		fmt.Print(err)
		os.Exit(1)
	}

	for pkgName, pkg := range pkgs {
		for _, f := range pkg.Files {
			for _, imp := range f.Imports {
				impName := imp.Path.Value
				if !contains(set[pkgName], impName) {
					set[pkgName] = append(set[pkgName], impName)
				}
			}
		}
	}

	for _, imps := range set {
		for _, imp := range imps {
			a := strings.TrimPrefix(imp, "\"")
			b := strings.TrimSuffix(a, "\"")
			fmt.Println(b)
		}
	}
}

func contains(xs []string, s string) bool {
	c := false
	for _, x := range xs {
		c = c || (x == s)
	}
	return c
}
