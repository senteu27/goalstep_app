const addConditionButton = document.querySelector('#add-condition');
const conditions = document.querySelector('#conditions');

addConditionButton.addEventListener('click', () => {
  const row = document.createElement('div');
  row.className = 'condition-row';

  const input = document.createElement('input');
  input.className = 'condition';
  input.placeholder = '条件を入力';

  row.appendChild(input);
  conditions.appendChild(row);
  input.focus();
});

window.addEventListener('turbo:load', document);