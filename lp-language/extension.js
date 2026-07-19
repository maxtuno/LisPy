const vscode = require("vscode");

/**
 * Activates the LP language extension.
 * Registers language configuration programmatically for features that require
 * runtime access to the VS Code API (indentation rules, word patterns, etc.).
 */
function activate(context) {
  const languageId = "lp";

  // Programmatic language configuration supplements the static JSON file.
  // The static file handles: comments, brackets, autoClosingPairs, surroundingPairs,
  // indentationRules, and onEnterRules. This override ensures runtime consistency.
  vscode.languages.setLanguageConfiguration(languageId, {
    indentationRules: {
      increaseIndentPattern: new RegExp(
        "^\\s*(class|def|async\\s+def|except|for|async\\s+for|if|elif|while|" +
        "with|async\\s+with|match|case|else|try|finally)\\b.*:\\s*(#.*)?$|^\\s*\\([^)]*$"
      ),
      decreaseIndentPattern: new RegExp(
        "^\\s*(pass|raise|break|continue|return)\\b|^\\s*\\)"
      ),
      indentNextLinePattern: /\\\s*$/
    },
    onEnterRules: [
      {
        // Multi-line backslash continuation: indent next line
        beforeText: /^((?!\\)).+\\\s*$/,
        action: { indent: "indent" }
      },
      {
        // Lisp semicolon comment continuation
        beforeText: /^(\s*);\s*/,
        afterText: /^$/,
        action: { indent: "none", appendText: "; " }
      },
      {
        // Python # comment continuation
        beforeText: /^(\s*)#\s*/,
        afterText: /^$/,
        action: { indent: "none", appendText: "# " }
      },
      {
        // Python block-beginning keywords: indent after colon
        beforeText: new RegExp(
          "^\\s*(class|def|async\\s+def|except|for|async\\s+for|if|elif|while|" +
          "with|async\\s+with|match|case|else|try|finally)\\b.*:\\s*(#.*)?$"
        ),
        action: { indent: "indent" }
      },
      {
        // Python block-ending keywords: outdent
        beforeText: /^\s*(pass|raise|break|continue)\b/,
        action: { indent: "outdent" }
      },
      {
        // Lisp open paren at line end: indent body
        beforeText: /^\s*\([^)]*$/,
        action: { indent: "indent" }
      },
      {
        // Lisp close paren at line start: outdent
        beforeText: /^\s*\)/,
        action: { indent: "outdent" }
      }
    ],
    wordPattern: /(-?)(\d*\.?\d+[a-zA-Z]?)|([a-zA-Z_#*][a-zA-Z0-9#_]*)|(:[a-zA-Z_][a-zA-Z0-9_]*)/,
    brackets: [
      ["(", ")"],
      ["[", "]"],
      ["{", "}"]
    ]
  });
}

function deactivate() {}

module.exports = { activate, deactivate };
