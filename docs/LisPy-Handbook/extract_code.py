import re, os, glob

chapters_dir = 'chapters'
output_base = 'codigos'

chapter_map = [
    ('chap-0-1-manifesto.tex', '00-01'), ('chap-0-2-howtoread.tex', '00-02'),
    ('chap-0-3-roadmap.tex', '00-03'),     ('chap-0-4-dependencies.tex', '00-04'),
    ('chap-0-5-epilogue.tex', '00-05'),
    ('chap-1-1-installation.tex', '01-01'), ('chap-1-2-atoms.tex', '01-02'),
    ('chap-1-3-lists.tex', '01-03'), ('chap-1-4-vectors.tex', '01-04'),
    ('chap-1-5-hashtables.tex', '01-05'), ('chap-1-6-control-flow.tex', '01-06'),
    ('chap-1-7-iteration-recursion.tex', '01-07'), ('chap-1-8-io.tex', '01-08'),
    ('chap-2-1-functions.tex', '02-01'), ('chap-2-2-symbols-packages.tex', '02-02'),
    ('chap-2-3-macros.tex', '02-03'), ('chap-2-4-clos-basics.tex', '02-04'),
    ('chap-2-5-clos-advanced.tex', '02-05'), ('chap-2-6-conditions.tex', '02-06'),
    ('chap-2-7-loop-advanced.tex', '02-07'), ('chap-2-8-files-streams.tex', '02-08'),
    ('chap-2-9-compilation.tex', '02-09'),
    ('chap-3-1-python-first-steps.tex', '03-01'), ('chap-3-2-type-conversion.tex', '03-02'),
    ('chap-3-3-python-api.tex', '03-03'), ('chap-3-4-reader-macro-underscore.tex', '03-04'),
    ('chap-3-5-memory-model.tex', '03-05'), ('chap-3-6-cross-debugging.tex', '03-06'),
    ('chap-3-7-callbacks.tex', '03-07'), ('chap-3-8-performance.tex', '03-08'),
    ('chap-3-9-ffi.tex', '03-09'),
    ('chap-4-1-python-template.tex', '04-01'), ('chap-4-2-pythonic-macro.tex', '04-02'),
    ('chap-4-3-defpyfun.tex', '04-03'), ('chap-4-4-numpy-fast.tex', '04-04'),
    ('chap-4-5-defnp.tex', '04-05'), ('chap-4-6-sympy-bridge.tex', '04-06'),
    ('chap-4-7-defmath.tex', '04-07'), ('chap-4-8-persist.tex', '04-08'),
    ('chap-4-9-continuations.tex', '04-09'), ('chap-4-10-import-hooks.tex', '04-10'),
    ('chap-4-11-pandas-bridge.tex', '04-11'),
    ('chap-4-12-hybrid-syntax.tex', '04-12'),
    ('chap-5-1-defpyclass.tex', '05-01'), ('chap-5-2-clos-python-sync.tex', '05-02'),
    ('chap-5-3-transformation-macros.tex', '05-03'), ('chap-5-4-quasiquoting-templates.tex', '05-04'),
    ('chap-5-5-ast-transformation.tex', '05-05'), ('chap-5-6-custom-reader-macros.tex', '05-06'),
    ('chap-5-7-module-system.tex', '05-07'), ('chap-5-8-debugging-metaprograms.tex', '05-08'),
    ('chap-6-1-workbench-intro.tex', '06-01'), ('chap-6-2-symbolic-calculus.tex', '06-02'),
    ('chap-6-3-linear-algebra.tex', '06-03'), ('chap-6-4-optimization.tex', '06-04'),
    ('chap-6-5-ode-integration.tex', '06-05'), ('chap-6-6-visualization.tex', '06-06'),
    ('chap-6-7-signal-processing.tex', '06-07'), ('chap-6-8-machine-learning.tex', '06-08'),
    ('chap-7-1-compiler.tex', '07-01'), ('chap-7-2-cli-environment.tex', '07-02'),
    ('chap-7-3-pip-packages.tex', '07-03'), ('chap-7-4-embedding-distribution.tex', '07-04'),
    ('chap-7-5-testing.tex', '07-05'), ('chap-7-6-ci-release.tex', '07-06'),
    ('chap-7-7-security.tex', '07-07'),
    ('chap-7-8-jupyter.tex', '07-08'),
    ('chap-8-1-robot-dynamics.tex', '08-01'), ('chap-8-2-trading-engine.tex', '08-02'),
    ('chap-8-3-image-processor.tex', '08-03'), ('chap-8-4-chatbot.tex', '08-04'),
    ('chap-8-5-search-engine.tex', '08-05'), ('chap-8-6-dsl-data-analysis.tex', '08-06'),
    ('chap-8-7-migration.tex', '08-07'),
    ('chap-10-library-overview.tex', '10-00'),
    ('chap-11-competitive-programming.tex', '11-00'),
    ('appendix-a-quickref.tex', 'A'), ('appendix-b-error-reference.tex', 'B'),
    ('appendix-c-type-conversion.tex', 'C'), ('appendix-d-builtins.tex', 'D'),
    ('appendix-e-clos-reference.tex', 'E'), ('appendix-f-python-api.tex', 'F'),
    ('appendix-g-build-config.tex', 'G'), ('appendix-h-bibliography.tex', 'H'),
]

total_blocks = 0

for filename, ch_num in chapter_map:
    filepath = os.path.join(chapters_dir, filename)
    if not os.path.exists(filepath):
        continue
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    patterns = [
        (re.compile(r'\\begin\{lispcode\}[^\n]*\n(.*?)\\end\{lispcode\}', re.DOTALL), '.lp'),
        (re.compile(r'\\begin\{pycode\}[^\n]*\n(.*?)\\end\{pycode\}', re.DOTALL), '.py'),
        (re.compile(r'\\begin\{lstlisting\}.*?\n(.*?)\\end\{lstlisting\}', re.DOTALL), '.txt'),
    ]

    blocks = []
    for pat, ext in patterns:
        matches = pat.findall(content)
        for m in matches:
            m = m.replace('\\#', '#')
            m = m.replace('\\%', '%')
            m = m.replace('\\&', '&')
            m = m.replace('\\{', '{')
            m = m.replace('\\}', '}')
            lines = []
            for line in m.split('\n'):
                stripped = line.strip()
                if stripped.startswith(';; Terminal:') or stripped.startswith(';;   lispy'):
                    continue
                lines.append(line)
            code = '\n'.join(lines).strip()
            if code:
                blocks.append((ext, code))

    if blocks:
        ch_dir = os.path.join(output_base, ch_num)
        os.makedirs(ch_dir, exist_ok=True)
        for i, (ext, code) in enumerate(blocks):
            fname = f'ejemplo-{i+1:02d}{ext}'
            fpath = os.path.join(ch_dir, fname)
            with open(fpath, 'w', encoding='utf-8') as f:
                f.write(code + '\n')
            total_blocks += 1

print(f'Total code blocks extracted: {total_blocks}')
