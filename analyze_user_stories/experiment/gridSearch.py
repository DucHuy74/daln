import numpy as np
import multiprocessing as mp

# chạy phương pháp phi tuyến với Beta chạy từ 0.1 -> 5 bước nhảy 0.1 và bias từ -5 đến 5 bước nhảy 0.1
# nếu chạy hết các trên thì không khả quan lên giảm khoảng tìm kiếm lại để tìm ra khu vực vàng


# cấu hình để chạy phương pháp phi tuyến tính với nhiều process chọn ra con số tối ưu nhất
class GridSearchConfig:
    def __init__(self, wordSimilarity, calculate_nonlinear_fusion):
        self.wordSimilarity = wordSimilarity
        self.calculate_nonlinear_fusion = calculate_nonlinear_fusion
        # có thể set phạm vi search của beta1, beta2, bias_b ở đây
        # tránh việc set range quá lớn và bước nhảy quá nhỏ
        beta1_space = np.arange(4, 5.1, 0.5)
        beta2_space = np.arange(0.5, 1.5, 0.5)
        bias_b_space = np.arange(-2.5, -1.5, 0.5)
        self.all_tasks = [(b1, b2, b) for b1 in beta1_space for b2 in beta2_space for b in bias_b_space]
        pass


    # beta1_space = np.arange(0.1, 5.1, 0.5)
    # beta2_space = np.arange(0.1, 5.1, 0.5)
    # bias_b_space = np.arange(-5.0, 5.1, 1)

    # kết quả cho ra HOÀN THÀNH TÌM KIẾM TỐI ƯU
    #    Max Total Score: 3.0139
    #    Tham số Tối ưu: Beta1=4.60, Beta2=1.10, Bias=-2.00
    # Best result: {'Sim353': {'Pearson_r': np.float64(0.6516385649256939), 'Spearman_rho': np.float64(0.6865746543934216)}, 'RG65': {'Pearson_r': np.float64(0.8503901165925516), 'Spearman_rho': np.float64(0.8252559841465325)}}

    # # tiếp tục với phạm vi nhỏ hơn
    # beta1_space = np.arange(4, 5.1, 0.1)
    # beta2_space = np.arange(0.5, 1.5, 0.1)
    # bias_b_space = np.arange(-2.5, -1.5, 0.1)

    #  Max Total Score: 3.0226
    #    Tham số Tối ưu: Beta1=5.00, Beta2=1.30, Bias=-2.00
    # Best result: {'Sim353': {'Pearson_r': np.float64(0.6537638244125639), 'Spearman_rho': np.float64(0.6830692713357924)}, 'RG65': {'Pearson_r': np.float64(0.8533847505504455), 'Spearman_rho': np.float64(0.8323371001121965)}}



    # print(f"Total tasks to process: {all_tasks[0]} and len of tasks: {len(all_tasks)}")
    def worker(self, params):
        print(f"Processing with params: {params}")
        beta1, beta2, bias_b = params

        result_nonlinear_fusion_method = self.wordSimilarity.run(self.calculate_nonlinear_fusion, beta1=beta1, beta2=beta2, bias_b=bias_b)

        ## tổng độ tương quan p và r của 4 dataset
        total_score = result_nonlinear_fusion_method["Sim353"]["Pearson_r"] + result_nonlinear_fusion_method["Sim353"]["Spearman_rho"] + \
            result_nonlinear_fusion_method["RG65"]["Pearson_r"] + result_nonlinear_fusion_method["RG65"]["Spearman_rho"] + \
            result_nonlinear_fusion_method["MC30"]["Pearson_r"] + result_nonlinear_fusion_method["MC30"]["Spearman_rho"] + \
            result_nonlinear_fusion_method["SimLex999"]["Pearson_r"] + result_nonlinear_fusion_method["SimLex999"]["Spearman_rho"]
        
        return (total_score, beta1, beta2, bias_b, 
                    result_nonlinear_fusion_method["Sim353"]["Pearson_r"], result_nonlinear_fusion_method["Sim353"]["Spearman_rho"], result_nonlinear_fusion_method["RG65"]["Pearson_r"], result_nonlinear_fusion_method["RG65"]["Spearman_rho"], 
                    result_nonlinear_fusion_method["MC30"]["Pearson_r"], result_nonlinear_fusion_method["MC30"]["Spearman_rho"],
                    result_nonlinear_fusion_method["SimLex999"]["Pearson_r"], result_nonlinear_fusion_method["SimLex999"]["Spearman_rho"])
        


    def parallel_grid_search(self):
        total_runs = len(self.all_tasks)
        print(f"Tổng số lần chạy cần thiết: {total_runs}")

        with mp.Pool(processes=5) as pool:
            # map() hoặc starmap() gửi các tuple tham số đến hàm worker
            results = pool.map(self.worker, self.all_tasks)

        max_total = -float('inf')
        best_params = None
        best_result = None
        # Chuẩn bị dữ liệu cho biểu đồ
        beta1_coords = []
        beta2_coords = []
        total_scores = []

        for result in results:
            if(result is None): continue

            total, b1, b2, b, r_s, rho_s, r_r, rho_r, r_m, rho_m, r_l, rho_l = result
            beta1_coords.append(b1)
            beta2_coords.append(b2)
            total_scores.append(total)
    
            if total > max_total:
                max_total = total
                best_params = (b1, b2, b)
                best_result = {
                    "Sim353": {"Pearson_r": r_s, "Spearman_rho": rho_s},
                    "RG65": {"Pearson_r": r_r, "Spearman_rho": rho_r},
                    "MC30": {"Pearson_r": r_m, "Spearman_rho": rho_m},
                    "SimLex999": {"Pearson_r": r_l, "Spearman_rho": rho_l}
                }
        print("\n" + "=" * 50)
        print(f"HOÀN THÀNH TÌM KIẾM TỐI ƯU")
        print(f"   Max Total Score: {max_total:.4f}")
        print(f"   Tham số Tối ưu: Beta1={best_params[0]:.2f}, Beta2={best_params[1]:.2f}, Bias={best_params[2]:.2f}")
        print(f"Best result: {best_result}")
        print("=" * 50)
        return best_result
