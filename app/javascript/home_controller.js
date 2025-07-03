
// グローバルクリックイベントリスナー
const globalClickHandler = (event) => {
  const button = event.target.closest('button');
  if (!button) return;

  // ボタンのクラスに応じて処理を振り分け
  if (button.classList.contains('achievement-button')) {
    event.preventDefault();
    handleAchievementClick(button);
  } else if (button.classList.contains('reset-achievement-button')) {
    event.preventDefault();
    handleResetAchievement(button);
  } else if (button.classList.contains('try-another-button')) {
    event.preventDefault();
    handleTryAnother(button);
  }
};

// イベントリスナーの初期化
const initializeEventListeners = () => {
  // 既存のリスナーを削除
  document.removeEventListener('click', globalClickHandler);
  // 新しいリスナーを追加
  document.addEventListener('click', globalClickHandler);
  console.log('Event listeners initialized.');
};

// Turbo Driveの読み込みイベントに対応
document.addEventListener('turbo:load', () => {
  initializeEventListeners();
});

// 初期読み込みにも対応
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeEventListeners);
} else {
  initializeEventListeners();
}

// CSRFトークン取得関数
function getCSRFToken() {
  const token = document.querySelector('meta[name="csrf-token"]');
  return token ? token.getAttribute('content') : null;
}

// 実績ボタンの処理関数
function handleAchievementClick(button) {
  console.log('handleAchievementClick called with button:', button);
  
  const activityType = button.getAttribute('data-activity-type');
  const achievementSection = button.closest('.achievement-section');
  const tryAnotherButton = achievementSection.querySelector(`.${activityType}-try-another`);
  const currentId = tryAnotherButton?.getAttribute(`data-${activityType}-id`);
  
  console.log('Activity Type:', activityType);
  console.log('Current ID:', currentId);
  
  if (!activityType) {
    console.error('Activity type not found on button');
    showNotification('ボタンの設定エラーが発生しました。', 'error');
    return;
  }
  
  // CSRFトークンの取得
  const csrfToken = getCSRFToken();
  if (!csrfToken) {
    console.error('CSRF token not found');
    showNotification('セキュリティエラーが発生しました。', 'error');
    return;
  }
  
  // ボタンを無効化
  button.disabled = true;
  button.style.opacity = '0.6';
  
  console.log('Sending fetch request to /home/record_achievement');
  
  // フォームデータとして送信
  const formData = new FormData();
  formData.append('activity_type', activityType);
  if (currentId) {
    formData.append('activity_id', currentId);
  }
  
  fetch('/home/record_achievement', {
    method: 'POST',
    headers: {
      'X-CSRF-Token': csrfToken,
      'Accept': 'application/json'
    },
    body: formData
  })
      .then(response => {
        console.log('Response status:', response.status);
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        console.log('Response data:', data);
        if (data.success) {
          // 成功時の処理
          achievementSection.innerHTML = `
            <div class="achievement-completed">
              <span class="achievement-icon">✅</span>
              <span class="achievement-text">${activityType === 'stretch' ? 'ストレッチ' : '呼吸法'}完了！</span>
              <div class="achievement-buttons">
                <button class="reset-achievement-button ${activityType}-reset-button" data-activity-type="${activityType}">
                  <span class="button-icon">🔄</span>
                  <span class="button-text">やり直す</span>
                </button>
                <button class="try-another-button ${activityType}-try-another" data-${activityType}-id="${currentId}">
                  <span class="button-icon">🔄</span>
                  <span class="button-text">別の${activityType === 'stretch' ? 'ストレッチ' : '呼吸法'}も試す</span>
                </button>
              </div>
            </div>
          `;
          
          // 成功メッセージを表示
          showNotification(data.message, 'success');
          
          // 応援メッセージを表示
          if (data.encouragement_message) {
            setTimeout(() => {
              showEncouragementModal(data.encouragement_message, activityType);
            }, 1000);
          }
        }
      })
      .catch(error => {
        console.error('Fetch Error:', error);
        button.disabled = false;
        button.style.opacity = '1';
        showNotification('通信エラーが発生しました。もう一度お試しください。', 'error');
      });
  } catch (error) {
    console.error('JavaScript Error:', error);
    button.disabled = false;
    button.style.opacity = '1';
    showNotification('JavaScriptエラーが発生しました。', 'error');
  }
}

// やり直し機能
function handleResetAchievement(button) {
  const activityType = button.getAttribute('data-activity-type');
  const achievementSection = button.closest('.achievement-section');
  const tryAnotherButton = achievementSection.querySelector(`.${activityType}-try-another`);
  const currentId = tryAnotherButton?.getAttribute(`data-${activityType}-id`);
  
  // ボタンを無効化
  button.disabled = true;
  button.style.opacity = '0.6';
  
  // CSRFトークンの取得
  const csrfToken = getCSRFToken();
  if (!csrfToken) {
    console.error('CSRF token not found');
    showNotification('セキュリティエラーが発生しました。', 'error');
    return;
  }
  
  // フォームデータとして送信（より確実）
  const formData = new FormData();
  formData.append('activity_type', activityType);
  if (currentId) {
    formData.append('activity_id', currentId);
  }
  
  fetch('/home/reset_achievement', {
    method: 'POST',
    headers: {
      'X-CSRF-Token': csrfToken,
      'Accept': 'application/json'
    },
    body: formData
  })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // 成功時の処理
        achievementSection.innerHTML = `
          <div class="achievement-buttons">
            <button class="achievement-button ${activityType}-button" data-activity-type="${activityType}">
              <span class="button-icon">${activityType === 'stretch' ? '🧘‍♀️' : '💨'}</span>
              <span class="button-text">${activityType === 'stretch' ? 'ストレッチしたよ' : '呼吸したよ'}</span>
            </button>
            <button class="try-another-button ${activityType}-try-another" data-${activityType}-id="${currentId}">
              <span class="button-icon">🔄</span>
              <span class="button-text">別の${activityType === 'stretch' ? 'ストレッチ' : '呼吸法'}も試す</span>
            </button>
          </div>
        `;
        
        // 成功メッセージを表示
        showNotification(data.message, 'success');
      }
    })
    .catch(error => {
      console.error('Error:', error);
      button.disabled = false;
      button.style.opacity = '1';
      showNotification('エラーが発生しました。もう一度お試しください。', 'error');
    });
}

// 別のストレッチ・呼吸法を試す機能
function handleTryAnother(button) {
  const isStretch = button.classList.contains('stretch-try-another');
  const currentId = button.getAttribute(isStretch ? 'data-stretch-id' : 'data-breathing-id');
  const endpoint = isStretch ? '/home/get_another_stretch' : '/home/get_another_breathing';
  
  console.log('handleTryAnother called:', { isStretch, currentId, endpoint });
  
  // ボタンを無効化
  button.disabled = true;
  button.style.opacity = '0.6';
  
  fetch(`${endpoint}?current_id=${currentId}`, {
    method: 'GET',
    headers: {
      'Accept': 'application/json'
    }
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      // コンテンツを更新
      const card = button.closest('.content-card');
      const cardContent = card.querySelector('.card-content');
      
      if (isStretch) {
        // ストレッチの内容を更新
        const stretch = data.stretch;
        cardContent.innerHTML = `
          <h3>${stretch.name}</h3>
          <p>${stretch.description}</p>
          <div class="duration-badge">約${stretch.duration}分</div>
          <span class="category-badge">${stretch.difficulty}</span>
          
          <!-- 実績ボタン -->
          <div class="achievement-section">
            <div class="achievement-buttons">
              <button class="achievement-button stretch-button" data-activity-type="stretch">
                <span class="button-icon">🧘‍♀️</span>
                <span class="button-text">ストレッチしたよ</span>
              </button>
              <button class="try-another-button stretch-try-another" data-stretch-id="${stretch.id}">
                <span class="button-icon">🔄</span>
                <span class="button-text">別のストレッチも試す</span>
              </button>
            </div>
          </div>
        `;
      } else {
        // 呼吸法の内容を更新
        const breathing = data.breathing;
        cardContent.innerHTML = `
          <h3>${breathing.name}</h3>
          <p>${breathing.description}</p>
          <div class="duration-badge">約${breathing.duration}分</div>
          <span class="category-badge">${breathing.technique}</span>
          
          <!-- 実績ボタン -->
          <div class="achievement-section">
            <div class="achievement-buttons">
              <button class="achievement-button breathing-button" data-activity-type="breathing">
                <span class="button-icon">💨</span>
                <span class="button-text">呼吸したよ</span>
              </button>
              <button class="try-another-button breathing-try-another" data-breathing-id="${breathing.id}">
                <span class="button-icon">🔄</span>
                <span class="button-text">別の呼吸法も試す</span>
              </button>
            </div>
          </div>
        `;
      }
      
      // 成功メッセージを表示
      showNotification(`新しい${isStretch ? 'ストレッチ' : '呼吸法'}を表示しました！`, 'success');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    button.disabled = false;
    button.style.opacity = '1';
    showNotification('エラーが発生しました。もう一度お試しください。', 'error');
  });
}

// 通知表示関数
function showNotification(message, type) {
  const notification = document.createElement('div');
  notification.className = `notification ${type}`;
  notification.textContent = message;
  
  document.body.appendChild(notification);
  
  // 3秒後に削除
  setTimeout(() => {
    notification.remove();
  }, 3000);
}


// 応援メッセージモーダル表示関数
function showEncouragementModal(message, activityType) {
  const modal = document.createElement('div');
  modal.className = 'encouragement-modal';
  modal.innerHTML = `
    <div class="encouragement-modal-content">
      <div class="encouragement-modal-header">
        <div class="encouragement-modal-icon">💝</div>
        <h3 class="encouragement-modal-title">今日の応援メッセージ</h3>
      </div>
      <div class="encouragement-modal-body">
        <div class="encouragement-modal-message">${message}</div>
        <div class="encouragement-modal-time">${new Date().toLocaleString('ja-JP', { timeZone: 'Asia/Tokyo' })}</div>
      </div>
      <div class="encouragement-modal-footer">
        <button class="encouragement-modal-button" onclick="this.closest('.encouragement-modal').remove()">
          <span class="button-icon">💕</span>
          <span class="button-text">ありがとう！</span>
        </button>
      </div>
    </div>
  `;
  
  document.body.appendChild(modal);
  
  // アニメーション効果
  setTimeout(() => {
    modal.classList.add('show');
  }, 100);
}
