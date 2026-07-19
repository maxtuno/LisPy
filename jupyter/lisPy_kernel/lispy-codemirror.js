/**
 * LisPy CodeMirror 6 Language Support for JupyterLab 4+ / Notebook 7+
 *
 * Auto-loaded via customCodeMirrorConfig in JupyterLab settings.
 * Provides syntax highlighting for .lp files (Lisp + Python hybrid).
 *
 * The @codemirror/language dependency is loaded via CDN (esm.sh) because
 * JupyterLab's dynamic import() uses native browser module resolution,
 * which does not expose JupyterLab's internal webpack-federated modules.
 */
import { StreamLanguage } from "https://esm.sh/@codemirror/language@6.10.7";

const lispyMode = StreamLanguage.define({
  name: "lispy",

  startState() {
    return { inString: false, inBlockComment: false };
  },

  token(stream, state) {
    if (state.inString) {
      if (stream.peek() === '"') {
        stream.next();
        state.inString = false;
        return "string";
      }
      stream.next();
      return stream.eol() ? "string" : "string";
    }

    if (state.inBlockComment) {
      while (!stream.eol()) {
        if (stream.peek() === "|" && stream.peek(1) === "#") {
          stream.pos += 2;
          state.inBlockComment = false;
          return "comment";
        }
        stream.next();
      }
      return "comment";
    }

    if (stream.eatSpace()) return null;

    const ch = stream.peek();

    if (ch === ";") {
      stream.skipToEnd();
      return "comment";
    }

    if (ch === '"') {
      stream.next();
      state.inString = true;
      return "string";
    }

    if (ch === "#") {
      stream.next();
      if (stream.peek() === "|") {
        stream.next();
        state.inBlockComment = true;
        return "comment";
      }
      if (stream.peek() === "_") {
        stream.next();
        stream.eatWhile(/[a-zA-Z]/);
        if (stream.peek() === ":") stream.eatWhile(/[a-zA-Z0-9\-:]/);
        return "keyword";
      }
      if (stream.match(/^['(.\+\-]/)) return "operator";
      stream.eatWhile(/[a-zA-Z]/);
      return "keyword";
    }

    if (ch === "(" || ch === ")") {
      stream.next();
      return "bracket";
    }

    if (ch === "'") {
      stream.next();
      return "quote";
    }

    if (ch === "`") {
      stream.next();
      return "quote";
    }

    if (ch === ",") {
      stream.next();
      if (stream.peek() === "@") stream.next();
      return "quote";
    }

    if (ch === "@") {
      stream.next();
      stream.eatWhile(/[a-zA-Z0-9_]/);
      while (stream.peek() === ":" || stream.peek() === ".") {
        stream.next();
        stream.eatWhile(/[a-zA-Z0-9_]/);
      }
      return "keyword";
    }

    if (ch === ":") {
      stream.next();
      stream.eatWhile(/[a-zA-Z0-9\-]*/);
      return "attribute";
    }

    if (/^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$/.test(
          stream.string.slice(stream.pos, stream.pos + 20).match(
            /^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?/
          )?.[0] || ""
        )) {
      stream.eatWhile(/[+\-]?\d*\.?\d*(?:[eE][+\-]?\d+)?/);
      return "number";
    }

    if (stream.eatWhile(/[a-zA-Z0-9\-*+/><=?!$%&@~^_]/)) {
      const word = stream.current().toLowerCase();

      if (word === "t" || word === "nil") return "atom";

      if (/^(defun|defmacro|defgeneric|defmethod|defclass|defstruct|defvar|defparameter|defconstant|let|let\*|lambda|flet|labels|if|when|unless|cond|case|loop|dolist|dotimes|progn|return|setf|setq|quote|and|or|not)$/.test(word))
        return "keyword";

      if (/^(car|cdr|cons|list|append|reverse|length|nth|mapcar|reduce|apply|funcall|print|format|read|load|eval|sqrt|abs|mod|exp|expt|log|sin|cos|tan|max|min|floor|ceiling|round|truncate|make-hash-table|gethash|make-array|aref|vector|subseq|sort|stable-sort|merge|find|remove|position|count|subst|member|assoc|coerce|typep|gensym|intern|symbol-name|symbol-value)$/.test(word))
        return "builtin";

      if (/^py:[a-zA-Z][a-zA-Z0-9\-]*$/.test(word)) return "keyword";

      if (/^(defpackage|in-package|import|export|use-package|find-package)$/.test(word))
        return "keyword";

      return "variableName";
    }

    stream.next();
    return null;
  },

  languageData: {
    commentTokens: { line: ";" },
    closeBrackets: { brackets: ["(", "[", "{"] },
    indentOnInput: /^\s*$/,
  },
});

export default function lispy() {
  return lispyMode;
}
