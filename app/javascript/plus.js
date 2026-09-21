document.addEventListener("DOMContentLoaded", () => {
  const conditions = document.getElementById("conditions");
  const addButton = document.getElementById("add-condition");
  const removeButton = document.getElementById("remove-condition");

  // ブラウザを開いた日の「今日」を YYYY-MM-DD 形式にする
  const today = new Date();
  const minDate = [
    today.getFullYear(),
    String(today.getMonth() + 1).padStart(2, "0"),
    String(today.getDate()).padStart(2, "0")
  ].join("-");

  addButton.addEventListener("click", () => {
    const number = conditions.children.length;

    const row = document.createElement("div");
    row.classList.add("condition-row");

    const stars = Array.from({ length: 5 }, (_, index) => {
      const level = 5 - index;
      const id = `goal_min_goals_attributes_${number}_importance_${level}`;

      return `
        <input
          type="radio"
          id="${id}"
          name="goal[min_goals_attributes][${number}][importance]"
          value="${level}"
          ${level === 0 ? "checked" : ""}
        >
        <label for="${id}" class="star" title="重要度 ${level}">★</label>
      `;
    }).join("");

    row.innerHTML = `
  <input
    class="min_goals"
    name="goal[min_goals_attributes][${number}][name]"
    placeholder="例：毎月1万円貯金する"
    required
  >

  <div class="deadline-and-importance">
    <input
      type="date"
      class="deadline"
      name="goal[min_goals_attributes][${number}][deadline]"
      aria-label="やることの期限"
      min="${minDate}"
      max="9999-12-31"
    >

    <div class="importance-rating">
      ${stars}
    </div>
  </div>
`;

    conditions.appendChild(row);
  });

  removeButton.addEventListener("click", () => {
    if (conditions.children.length > 1) {
      conditions.lastElementChild.remove();
    }
  });
});