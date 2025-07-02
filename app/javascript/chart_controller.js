import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["canvas", "summary"]

  connect() {
    this.loadChartData()
  }

  async loadChartData() {
    try {
      const response = await fetch('/api/monthly_stats')
      const data = await response.json()
      
      this.renderChart(data.chart_data)
      this.renderSummary(data.summary)
    } catch (error) {
      console.error('グラフデータの読み込みに失敗しました:', error)
    }
  }

  renderChart(chartData) {
    const ctx = this.canvasTarget.getContext('2d')
    
    // 既存のチャートがあれば破棄
    if (this.chart) {
      this.chart.destroy()
    }

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: chartData.labels,
        datasets: [
          {
            label: 'ストレッチ',
            data: chartData.stretch_data,
            borderColor: '#00b894',
            backgroundColor: 'rgba(0, 184, 148, 0.1)',
            tension: 0.4,
            fill: true
          },
          {
            label: '呼吸法',
            data: chartData.breathing_data,
            borderColor: '#0984e3',
            backgroundColor: 'rgba(9, 132, 227, 0.1)',
            tension: 0.4,
            fill: true
          },
          {
            label: '合計',
            data: chartData.total_data,
            borderColor: '#6c5ce7',
            backgroundColor: 'rgba(108, 92, 231, 0.1)',
            tension: 0.4,
            fill: false,
            borderWidth: 3
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top',
            labels: {
              font: {
                family: 'Noto Sans JP, sans-serif',
                size: 12
              },
              usePointStyle: true
            }
          },
          title: {
            display: true,
            text: '過去30日間の活動記録',
            font: {
              family: 'Noto Sans JP, sans-serif',
              size: 16,
              weight: '500'
            },
            color: '#2d3436'
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: '日付',
              font: {
                family: 'Noto Sans JP, sans-serif',
                size: 12
              }
            },
            ticks: {
              font: {
                family: 'Noto Sans JP, sans-serif',
                size: 10
              }
            }
          },
          y: {
            title: {
              display: true,
              text: '活動回数',
              font: {
                family: 'Noto Sans JP, sans-serif',
                size: 12
              }
            },
            ticks: {
              font: {
                family: 'Noto Sans JP, sans-serif',
                size: 10
              },
              stepSize: 1
            },
            beginAtZero: true
          }
        },
        interaction: {
          intersect: false,
          mode: 'index'
        }
      }
    })
  }

  renderSummary(summary) {
    if (this.hasSummaryTarget) {
      this.summaryTarget.innerHTML = `
        <div class="summary-grid">
          <div class="summary-item">
            <div class="summary-number">${summary.total_days}</div>
            <div class="summary-label">活動日数</div>
          </div>
          <div class="summary-item">
            <div class="summary-number">${summary.total_activities}</div>
            <div class="summary-label">総活動回数</div>
          </div>
          <div class="summary-item">
            <div class="summary-number">${summary.stretch_count}</div>
            <div class="summary-label">ストレッチ回数</div>
          </div>
          <div class="summary-item">
            <div class="summary-number">${summary.breathing_count}</div>
            <div class="summary-label">呼吸法回数</div>
          </div>
        </div>
      `
    }
  }
} 