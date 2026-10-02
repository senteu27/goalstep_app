document.addEventListener("change", async (event) => {
  const checkbox = event.target;

  if (!checkbox.matches(".min-goal-check")) return;

  const url = checkbox.dataset.updateUrl;
  const token = document.querySelector('meta[name="csrf-token"]').content;

  try {
    const response = await fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "text/plain"
      },
      body: JSON.stringify({
        min_goal: {
          check: checkbox.checked
        }
      })
    });

    if (!response.ok) {
      throw new Error("保存に失敗しました");
    }
  } catch (error) {
    checkbox.checked = !checkbox.checked;
    alert("保存できませんでした。もう一度試してください。");
    console.error(error);
  }
});