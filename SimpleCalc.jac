"""A Simple Calculator"""

import from mtllm.llms { OpenAI, Gemini }

glob llm = Gemini(model_name="gemini-1.5-flash", verbose=False);

"""Evaluate a mathematical expression and return the result"""
def calculate_expression(expression: str) -> float byllm();

walker Calculator {
    has expression: str;

    can start with `root entry;
    can process_expression with operation entry;
}

node operation {
    has result: float = None;
}

# Will run when in CLI mode (not in cloud)
with entry:__main__ {
    root spawn Calculator("2 + 3");
    root spawn Calculator("2**(0.5)");
    root spawn Calculator("d(2x)/dx");
    root spawn Calculator("e**2");
}

impl Calculator.start {
    if not [root --> (`?operation)] {
        next = root ++> operation();
    } else {
        next = [root --> (`?operation)];
    }
    visit next;
}

impl Calculator.process_expression {
    if [-->] {
        visit [-->];
    } else {
        result = calculate_expression(self.expression);
        here.result = result;
        print(f"Result of {self.expression} = {result}");
        disengage;
    }
}