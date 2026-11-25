import { marked } from "marked";
import DOMPurify from "dompurify";
document.addEventListener("turbo:load", () => {
  const aiButton = document.getElementById("ai-help");
  const chatArea = document.getElementById("ai-chat");
  const closeButton = document.getElementById("close-chat");
  const sendButton = document.getElementById("send-message");
  const messageInput = document.getElementById("chat-message");
  const messages = document.getElementById("chat-messages");
  const chatHeader = chatArea?.querySelector(".chat-header");

  // 目標作成画面以外では何もしない
  if (!aiButton || !chatArea) return;

  // AI相談画面を開く
  aiButton.addEventListener("click", () => {
    chatArea.hidden = false;
  });

  // AI相談画面を閉じる
  closeButton.addEventListener("click", () => {
    chatArea.hidden = true;
  });

  // Enterキーで送信
  messageInput.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      sendButton.click();
    }
  });

  // メッセージを送信する
  sendButton.addEventListener("click", async () => {
    const message = messageInput.value.trim();

    if (!message || sendButton.disabled) return;

    // 自分のメッセージを表示
    const userMessage = document.createElement("p");
    userMessage.textContent = "あなた：" + message;
    messages.appendChild(userMessage);

    messageInput.value = "";
    sendButton.disabled = true;

    try {
      const response = await fetch("/ai_chats", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ message: message })
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "通信に失敗しました");
      }

      // AIの返答を表示
      const aiMessage = document.createElement("div");
        aiMessage.classList.add("ai-message");

      const html = marked.parse(data.answer);

      const safeHtml = DOMPurify.sanitize(html, {
        ADD_ATTR: ["target", "rel"]
      });
         aiMessage.innerHTML = safeHtml;

      // リンクを新しいタブで開く
        aiMessage.querySelectorAll("a").forEach((link) => {
        link.setAttribute("target", "_blank");
        link.setAttribute("rel", "noopener noreferrer");
      });

    messages.appendChild(aiMessage);

    } catch (error) {
      const errorMessage = document.createElement("p");
      errorMessage.textContent = "エラー：" + error.message;
      messages.appendChild(errorMessage);

    } finally {
      sendButton.disabled = false;
      messages.scrollTop = messages.scrollHeight;
    }
  });

  // ヘッダーをドラッグして小窓を移動
  if (chatHeader) {
    chatHeader.addEventListener("pointerdown", (event) => {
      // 閉じるボタンを押した場合は移動しない
      if (event.target.closest("button")) return;

      const rect = chatArea.getBoundingClientRect();

      const offsetX = event.clientX - rect.left;
      const offsetY = event.clientY - rect.top;

      // 移動開始時に位置を固定
      chatArea.style.left = rect.left + "px";
      chatArea.style.top = rect.top + "px";
      chatArea.style.right = "auto";
      chatArea.style.bottom = "auto";

      const move = (e) => {
        const left = Math.max(
          0,
          Math.min(e.clientX - offsetX, window.innerWidth - rect.width)
        );

        const top = Math.max(
          0,
          Math.min(e.clientY - offsetY, window.innerHeight - rect.height)
        );

        chatArea.style.left = left + "px";
        chatArea.style.top = top + "px";
      };

      const stop = () => {
        document.removeEventListener("pointermove", move);
        document.removeEventListener("pointerup", stop);
      };

      document.addEventListener("pointermove", move);
      document.addEventListener("pointerup", stop);
    });
  }

  // 上下左右の端でサイズ変更
  const resizeEdges = ["right", "left", "top", "bottom"];

  resizeEdges.forEach((edge) => {
    const handle = document.createElement("div");

    handle.className = `resize-handle resize-${edge}`;
    chatArea.appendChild(handle);

    handle.addEventListener("pointerdown", (event) => {
      event.preventDefault();
      event.stopPropagation();

      const rect = chatArea.getBoundingClientRect();

      const startX = event.clientX;
      const startY = event.clientY;

      const startWidth = rect.width;
      const startHeight = rect.height;
      const startLeft = rect.left;
      const startTop = rect.top;

      // 位置を固定
      chatArea.style.left = startLeft + "px";
      chatArea.style.top = startTop + "px";
      chatArea.style.right = "auto";
      chatArea.style.bottom = "auto";

      const move = (e) => {
        const dx = e.clientX - startX;
        const dy = e.clientY - startY;

        const maxWidth = window.innerWidth - 20;
        const maxHeight = window.innerHeight - 20;

        if (edge === "right") {
          const width = Math.max(
            280,
            Math.min(maxWidth - startLeft, startWidth + dx)
          );
          chatArea.style.width = width + "px";
        }

        if (edge === "left") {
          const width = Math.max(
            280,
            Math.min(maxWidth, startWidth - dx)
          );
          chatArea.style.width = width + "px";
          chatArea.style.left = (startLeft + startWidth - width) + "px";
        }

        if (edge === "bottom") {
          const height = Math.max(
            300,
            Math.min(maxHeight - startTop, startHeight + dy)
          );
          chatArea.style.height = height + "px";
        }

        if (edge === "top") {
          const height = Math.max(
            300,
            Math.min(maxHeight, startHeight - dy)
          );
          chatArea.style.height = height + "px";
          chatArea.style.top = (startTop + startHeight - height) + "px";
        }
      };

      const stop = () => {
        document.removeEventListener("pointermove", move);
        document.removeEventListener("pointerup", stop);
      };

      document.addEventListener("pointermove", move);
      document.addEventListener("pointerup", stop);
    });
  });
});