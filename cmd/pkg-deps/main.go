package main

import (
	"fmt"
	"go/parser"
	"go/token"
	"os"
	"sort"
	"strings"
)

func main() {
	set := make([]string, 0)

	if len(os.Args) != 2 {
		fmt.Println("usage: " + os.Args[0] + " [PKG|DIR]")
		os.Exit(1)
	}

	pkgSpec := os.Args[1]
	var pkgPath string
	switch pkgSpec[0] {
	case '.', '/':
		pkgPath = pkgSpec
	default:
		pkgPath = os.Getenv("GOPATH") + "/src/" + pkgSpec
	}

	fset := token.NewFileSet()
	pkgs, err := parser.ParseDir(fset, pkgPath, nil, parser.ImportsOnly)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	for _, pkg := range pkgs {
		for _, f := range pkg.Files {
			for _, imp := range f.Imports {
				impName := imp.Path.Value
				if !contains(set, impName) {
					set = append(set, impName)
				}
			}
		}
	}

	sort.Strings(set)
	for _, imp := range set {
		a := strings.TrimPrefix(imp, "\"")
		b := strings.TrimSuffix(a, "\"")
		fmt.Println(b)
	}
}

func contains(xs []string, s string) bool {
	c := false
	for _, x := range xs {
		c = c || (x == s)
	}
	return c
}
